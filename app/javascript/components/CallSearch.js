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

  // TODO: make specific to deploy
  localStoreKey() {
    return 'moxCallSearch';
  }

  componentDidMount() {
    this.getCalls()
  }

  getCalls(e) {
    e && e.preventDefault();
    this.setState({ loading: true });

    var thisComponent = this;

    $.get("/v1/calls", this.callSearchOptions()).done(function(response) {
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

    let placeholder = "Search your calls";
    if (this.state.pagination) {
      placeholder = `${this.state.pagination.count} ${pluralize('call', this.state.pagination.count)} match`;
    }

    return (
      <div>
        <div className='row mb-3'>
          <div className='col-auto mr-auto'>
            <a className='btn btn-sm btn-light border' href='/calls/new'>
              + New Call
            </a>
          </div>
          <div className='col-auto'>
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
          <div className='row'>
            <div className='col-auto mr-auto d-flex d-justify-content-between'>
              { this.renderSortByDropdown() }
            </div>

            <div className='col-auto'>
              { this.toggleFilterButton() }

            </div>
          </div>
        </form>

        <div className='mt-2'>
          { this.renderFilterSection() }
        </div>

        <div className='gray'>
          { this.state.errorMessage }
        </div>

        { this.state.loading && (
          <div className='loader'></div>
        )}
        { !this.state.loading && (
          <div>
            <div className='mt-4'>
             { this.state.calls.map(this.renderCall) }
            </div>

            <div className='mt-4'>
              { this.state.pagination && this.state.pagination.pages > 1 && <Pagination pagination={this.state.pagination} onClick={function(e) { thisComponent.setLocalStorageFilters() }} /> }
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
      <div className="card mt-3 rounded-0 text-dark border-top-0 border-bottom-0 border-right-0 text-decoration-none hover-bg-light pt-3 px-2" key={ call.id }>
        <h5>
          <a className='card-title mb-0 text-dark' href={call.path}>
            { call.name || 'Unknown Name' }

            <div className='pull-right d-none d-md-block'>
              <span className="p-1">{this.state.call_type_emojis[call.call_type.name] || this.state.call_type_emojis['default']}</span>
            </div>
          </a>
        </h5>
        { call.scraped && (
          <small>
            <span className="d-inline badge badge-light border mr-1 p-1" >
              {call.spider}
            </span>
          </small>
        ) }

        <div className="card-body p-0">
          <div className='row mt-4'>
            <div className='col-auto mr-auto'>
              { call.entry_deadline && (
                <div className='text-muted'>
                  { call.entry_deadline }
                </div>
              ) }
            </div>
            <div className='col-auto'>
              { call.external && (
                <div className='text-right'>
                  <div>
                    { call.view_count } { pluralize('view', call.view_count) }
                  </div>
                </div>
              ) }

              { call.internal && (
                <div className='text-primary'>
                  { call.entry_counts.submitted } { pluralize('entry', call.entry_counts.submitted) } submitted
                </div>
              ) }
            </div>
          </div>

        </div>
      </div>
    );
  }

};
