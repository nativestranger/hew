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
    this.renderFiltersTop = this.renderFiltersTop.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // not used for now
  setLocalStorageFilters(property, value) {
    let filters = JSON.parse(localStorage.getItem('mox_call_search_filters'));
    filters[property] = value;
    localStorage.setItem('mox_call_search_filters', JSON.stringify(filters));
  }

  componentWillMount() {
    this.setState({
      activeFilterSection: 'call_types'
    }); // TODO: /// share w/ live search...

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

  getCalls(e) {
    e && e.preventDefault();
    let thisComponent = this;

    $.get("/v1/public/calls.json", this.callSearchOptions())
        .done(function(response) {
                  thisComponent.setState({
                    getError: false,
                    calls: response.records,
                    pagination: response.pagination,
                  });
                  // thisComponent.refs.submit.blur();
                })
        .fail(function(response) {
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
    let placeholder;

    if (this.state.pagination) {
      placeholder = `${this.state.pagination.count} calls match`;
    }

    return (
      <div className="call-searcher">
        <div className="filters">
          <form onSubmit={ this.getCalls }>
            <div className='form-group mb-0'>
              <div className='input-group'>
                <input id="search_bar"
                       className="form-control mb-2"
                       type='string'
                       ref='searchValInput'
                       defaultValue={ this.state.searchVal }
                       placeholder={placeholder}>
                </input>
                <div className="input-group-append" onClick={this.getCalls}>
                  <span className="input-group-btn">
                    <button name="button" type="button" className="btn btn-primary blr-0">
                      <i className="fa fa-search"></i>
                    </button>
                  </span>
                </div>
              </div>
            </div>
          </form>
        </div>

        <div className="row mb-4">
          <div className="col-12">
            { this.renderFiltersTop() }
            { this.renderFilterSection() }
          </div>
        </div>

        <div className="calls">
          { this.state.calls && this.state.calls.map(call => (
            <div onClick={function(){ window.location.pathname = `/calls/${call.id}/details`; }} target="_blank" className="row c-pointer mb-4 border-right border-bottom border-top py-2 text-dark" key={call.id}>
              <div className="col-12 mx-auto mt-2">
                <div className="card border-0">
                  <div className="card-header bg-white border-0 p-0">
                      <div className="row">
                          <div className="col-11">
                            <h5 className="mb-0">
                              <a href={`/calls/${call.id}/details`} className='d-inline-block text-dark'>{call.name}
                                { call.venue && (<h6 className="d-inline">@ {call.venue.id}</h6>) }
                              </a>
                            </h5>
                          </div>
                          <div className="col-1 d-flex justify-content-end">
                            <span className="p-1">{this.props.call_type_emojis[call.call_type.name] || this.props.call_type_emojis['default']}</span>
                          </div>
                      </div>
                  </div>
                  { call.description && (
                    <div className="card-body call-description my-1 p-0">
                      <div className="mb-0 text-truncate text-muted trix-content" dangerouslySetInnerHTML={{ __html: call.description }} />
                    </div>
                  ) }
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
            </div>
          )) }
        </div>

        { this.state.pagination && this.state.pagination.pages > 1 && <Pagination pagination={this.state.pagination} /> }
	    </div>
    );
  }

  renderFiltersTop() {
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
      <div className="bg-white p-0 mb-2 dropdowns d-flex justify-content-between">
        { thisComponent.renderSortByDropdown() }
        { this.toggleFilterButton() }
      </div>
    )
  }
}
