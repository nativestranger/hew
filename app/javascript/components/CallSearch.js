import React from "react";
import PropTypes from "prop-types";
import pluralize from "pluralize";

export default class CallSearch extends React.Component {

  static propTypes = {
    orderOptions: PropTypes.array.isRequired,
    calls: PropTypes.array.isRequired,
    searchVal: PropTypes.string
  };

  constructor(props) {
    super(props);
    this.state = Object.assign({}, props);
  }

  componentDidMount() {
    this.getCalls()
  }

  selectedOrderOption() {
    return this.state.orderOptions.find(option => option.selected);
  }

  renderSortByDropdown() {
    let thisComponent = this;

    let isSelected = function(orderOptionName) {
      return thisComponent.selectedOrderOption().name == orderOptionName;
    }
    let selectOrderOption = function(orderOptionName) {
      let orderOptions = [...thisComponent.state.orderOptions];
      orderOptions.forEach(option => {
        if (option.name === orderOptionName) {
          option.selected = true;
        } else {
          option.selected = false;
        }
      });
      thisComponent.setState({ orderOptions: orderOptions });
      thisComponent.getCalls();
    }

    return (
      <div className="dropdown d-inline">
          <button className="btn btn-sm btn-muted dropdown-toggle" type="button" data-toggle="dropdown">{this.selectedOrderOption().name}
          <span className="caret"></span></button>
          <ul className="dropdown-menu dropdown-menu-right text-center">
            { thisComponent.state.orderOptions.map(orderOption => {
              return (
                <li key={orderOption.name} className="dropdown-item c-pointer d-flex justify-content-start" onClick={ function(e) { e.preventDefault(); selectOrderOption(orderOption.name) } }>
                  { isSelected(orderOption.name) && <strong>{orderOption.name}</strong> }
                  { !isSelected(orderOption.name) && <span>{orderOption.name}</span> }
                </li>
              )
            }) }
          </ul>
      </div>
    );
  }

  getCalls = () => {
    var searchValInput = this.refs.searchValInput.value;
    this.setState({ loading: true });

    var thisComponent = this;

    $.get("/v1/calls", { name: searchValInput, order_option: this.selectedOrderOption() })
      .done(function(response) {
        thisComponent.setState({ calls: response.calls,
                                 searchVal: searchValInput,
                                 errorMessage: '',
                                 loading: false });
      }).fail(function(data) {
        thisComponent.setState({ errorMessage: 'Something went wrong...',
                                 searchVal: searchValInput,
                                 loading: false });
      });
    }

  selectedOrderOption() {
    return this.state.orderOptions.find(option => option.selected);
  }

  render() {
    if (this.state.loading) {
      return (
        <div className='loader'></div>
      );
    } else {
      return this.renderContent();
    }
  }

  renderContent() {
    var thisComponent = this;
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
          <div className='form-group'>
            <input id="search_bar"
                   className="form-control mb-2"
                   autoFocus={ true }
                   type='search'
                   ref='searchValInput'
                   defaultValue={ this.state.searchVal }
                   placeholder='Search Your Calls'>
            </input>
            <div className='row'>
              <div className='col-auto mr-auto'>
                <div>
                  <p className='text-muted'>{ thisComponent.state.calls.length + pluralize(' call', thisComponent.state.calls.length) }</p>
                </div>
              </div>
              <div className='col-auto'>
                { this.renderSortByDropdown() }
              </div>
            </div>
          </div>
        </form>

        <div className='gray'>
          { this.state.errorMessage }
        </div>

        <div className='mt-2'>
         { this.state.calls.map(this.renderCall) }
        </div>
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
      <a className="card mt-3 rounded-0 text-dark border-top-0 border-left-0 border-right-0 text-decoration-none hover-bg-light" href={ call.path } key={ call.id }>
        <h4 className='card-title mb-0'>
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
      </a>
    );
  }

};
