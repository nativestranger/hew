import React from "react";
import PropTypes from "prop-types";
import Pagination from "./Pagination";
import BaseCallSearch from "./BaseCallSearch";
import pluralize from "pluralize";

export default class CallSearch extends BaseCallSearch {
  static propTypes = {
    page: PropTypes.number.isRequired,
    orderOptions: PropTypes.array.isRequired,
    call_types: PropTypes.array.isRequired,
    call_type_emojis: PropTypes.object.isRequired,
    calls: PropTypes.array.isRequired,
    searchVal: PropTypes.string,
  };

  constructor(props) {
    super(props);
    this.getCalls = this.getCalls.bind(this);
    this.renderCall = this.renderCall.bind(this);
    this.state = Object.assign({}, props);
  }

  componentDidMount() {
    this.getCalls()
  }

  getCalls(e) {
    e && e.preventDefault();
    let searchValInput = this.refs.searchValInput.value;
    this.setState({ loading: true });

    var thisComponent = this;

    $.get("/v1/calls", {
       name: searchValInput,
       page: this.currentPage(),
       call_type_ids: this.selectedCallTypes().map(call_type => call_type.id),
       spiders: this.selectedSpiders().map(spider => spider.id),
       order_option: this.selectedOrderOption()
     }).done(function(response) {
        thisComponent.setState({
          calls: response.records,
          pagination: response.pagination,
          errorMessage: '',
          loading: false
        });
      }).fail(function(data) {
        thisComponent.setState({
          errorMessage: 'Something went wrong...',
          loading: false
        });
      });
  }

  render() {
    return this.renderContent();
  }

  renderContent() {
    let thisComponent = this;
    return (
      <div>
        <div className='row mb-3'>
          <div className='col-auto mr-auto'>
          </div>
          <div className='col-auto'>
            <a className='btn btn-sm btn-primary' href='/calls/new'>
              + New Call
            </a>
          </div>
        </div>

        <form onSubmit={ this.getCalls }>
          <div className='form-group mb-0'>
            <div className='input-group'>
              <input id="search_bar"
                     className="form-control mb-2"
                     type='string'
                     ref='searchValInput'
                     defaultValue={ this.state.searchVal }
                     placeholder='Search Your Calls'>
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
          <div className='row'>
            <div className='col-auto mr-auto'>
              { this.state.pagination && (
                <div>
                  <p className="text-muted m-1 text-right">{this.state.calls.length} of {this.state.pagination.count} {pluralize(' call', this.state.pagination.count) }</p>
                </div>
              ) }
            </div>
            <div className='col-auto'>
              { this.renderSpiderDropdown() }
              { this.renderCallTypeDropdown() }
              { this.renderSortByDropdown() }
            </div>
          </div>
        </form>

        <div className='gray'>
          { this.state.errorMessage }
        </div>

        { this.state.loading && (
          <div className='loader'></div>
        )}
        { !this.state.loading && (
          <div>
            <div className='mt-2'>
             { this.state.calls.map(this.renderCall) }
            </div>

            <div className='mt-4'>
              { this.state.pagination && this.state.pagination.pages > 1 && <Pagination pagination={this.state.pagination} /> }
            </div>
          </div>
        )}
      </div>
    );
  }

  renderCall(call) {
    const capitalize = (s) => {
      if (typeof s !== 'string') return ''
      return s.charAt(0).toUpperCase() + s.slice(1)
    }

    let callUser = call.call_users.find(cu => cu.user_id === App.currentUser().id);

    return (
      <div onClick={ function() { window.location.pathname = call.path } } className="card mt-3 rounded-0 text-dark border-top-0 border-left-0 border-right-0 text-decoration-none hover-bg-light c-pointer" key={ call.id }>
        <h4 className='card-title mb-0'>
          <span className="p-1">{this.state.call_type_emojis[call.call_type.name] || this.state.call_type_emojis['default']}</span>
          { call.name || 'Unknown Name' }

          { call.scraped && (
            <small className='pull-right'>
              <span className="d-inline badge badge-light border mr-1 p-1" >
                {call.spider}
              </span>
            </small>
          ) }
        </h4>

        <div className="card-body p-0">
          { call.time_until_deadline_in_words && (
            <p className='text-muted'>
              { call.time_until_deadline_in_words } left for entries
            </p>
          ) }

          { call.internal && (
            <div className='text-primary'>
              { call.entry_counts.submitted } { pluralize('entry', call.entry_counts.submitted) } submitted
            </div>
          ) }

          { call.external && (
            <div className='mt-4'>
              <a href={call.external_url}>
                External URL
              </a>
              <div>
                { call.view_count } { pluralize('view', call.view_count) }
              </div>
            </div>
          ) }
          <div className='clearfix mb-2' />
        </div>
      </div>
    );
  }

};
