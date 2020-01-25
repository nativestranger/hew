import React from "react";
import PropTypes from "prop-types";
import Pagination from "./Pagination";
import BaseCallSearch from "./BaseCallSearch";

export default class HomepageCallSearch extends BaseCallSearch {
  static propTypes = {
    page: PropTypes.number.isRequired,
    orderOptions: PropTypes.array.isRequired,
    call_types: PropTypes.array.isRequired,
    call_type_emojis: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);
    this.getCalls = this.getCalls.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // not used for now
  setLocalStorageFilters(property, value) {
    let filters = JSON.parse(localStorage.getItem('mox_call_search_filters'));
    filters[property] = value;
    localStorage.setItem('mox_call_search_filters', JSON.stringify(filters));
  }

  componentWillMount() {
    let filters;

    // TODO: clear on deploy && renable localStorage
    if (false && localStorage.getItem('mox_call_search_filters')) {
      filters = JSON.parse(localStorage.getItem('mox_call_search_filters'));
    } else {
      filters = {
        call_types: this.props.call_types,
        orderOptions: this.props.orderOptions
      }

      localStorage.setItem('mox_call_search_filters', JSON.stringify(filters));
    }

    this.setState({
      call_types: filters.call_types,
      calls: [],
      orderOptions: filters.orderOptions
    });
  }

  componentDidMount() {
    this.getCalls();
  }

  getCalls() {
    let thisComponent = this;

    // TODO: display pagination or reset page when results returned that make our current page # greater than pages returned
    let currentPage = (
      (this.state.pagination && this.state.pagination.current) || thisComponent.props.page
    );

    $.get("/v1/public/calls.json",
           { call_type_ids: this.selectedCallTypes().map(call_type => call_type.id),
             order_option: this.selectedOrderOption(),
             page: currentPage,
             authenticity_token: App.getMetaContent("csrf-token") })
        .done(function(data) {
                  thisComponent.setState({
                    getError: false,
                    calls: data.records,
                    pagination: data.pagination,
                  });
                  // thisComponent.refs.submit.blur();
                })
        .fail(function(data) {
                thisComponent.setState({ getError: 'Oops, something went wrong.'});
              })
        .always(function() { $(thisComponent.refs.submit).prop('disabled', false); });
  }

  handleSubmit(e) {
    e.preventDefault();
    $(this.refs.submit).prop('disabled', true);
    this.getCalls();
  }

  render() {
    let thisComponent = this;

    return (
      <div className="call-searcher">
        { this.renderFilterSection() }

        { this.state.pagination && (
          <div>
            <p className="text-muted m-1 text-right">{this.state.calls.length} of {this.state.pagination.count} calls</p>
          </div>
        ) }

        <div className="calls">
          { this.state.calls && this.state.calls.map(call => (
            <a href={`/calls/${call.id}/details`} target="_blank" className="row mb-4" key={call.id}>
                <div className="col-12 mx-auto">
                    <div className="card border-0">
                        <div className="card-header bg-white border-0 p-0">
                            <div className="row">
                                <div className="col-12">
                                    <h5 className="mb-0">
                                      <span className="p-1">{this.props.call_type_emojis[call.call_type.name] || this.props.call_type_emojis['default']}</span>
                                      <p className='d-inline-block'>{call.name}
                                        { call.venue && (<h6 className="d-inline">@ {call.venue.id}</h6>) }
                                      </p>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div className="card-body call-description my-1 p-0">
                          <div className="mb-0 text-truncate text-muted trix-content" dangerouslySetInnerHTML={{ __html: call.description }} />
                        </div>
                        <div className="card-footer bg-white border-0 p-0 text-muted">
                            <div className="row">
                                <div className="col-12">
                                    <div className="text-muted small">
                                        <span>{call.time_until_deadline_in_words} left</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </a>
          )) }
        </div>

        { this.state.pagination && this.state.pagination.pages > 1 && <Pagination pagination={this.state.pagination} /> }
	    </div>
    );
  }

  renderFilterSection() {
    let thisComponent = this;

    let renderCallType = function(callType) {
      return (
        <span key={callType.id} className="d-inline badge badge-light border mr-1 p-1 c-pointer" onClick={function() { thisComponent.toggleCallType(callType.name)}}>
          <span>{thisComponent.props.call_type_emojis[callType.enum_name] || thisComponent.props.call_type_emojis['default']}</span>
          {callType.name}
          <span className="fa fa-times fa-sm pl-1"></span>
        </span>
      );
    }

    return (
      <div className="filters card">
        <div className="search-container p-1">
          <span className="fa fa-search fa-sm p-2"></span>
          { this.selectedCallTypes().map(renderCallType) }
        </div>

        <div className="card-footer bg-white p-0">
          <div className="dropdowns d-flex justify-content-between">
            { thisComponent.renderCallTypeDropdown() }
            { thisComponent.renderSortByDropdown() }
          </div>
        </div>
      </div>
    )
  }
}
