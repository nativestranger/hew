import React from "react";
import PropTypes from "prop-types";
import pluralize from "pluralize";

// Consolidate call search?

// TODO: private by default and rename other to public!!!
export default class AuthCallSearch extends React.Component {

  static propTypes = {
    calls: PropTypes.array.isRequired,
    searchVal: PropTypes.string
  };

  constructor(props) {
    super(props);
    this.state = Object.assign({}, props);
  }

  componentDidMount() {
    this.all()
  }

  handleSubmit = (e) => {
    e.preventDefault();
    var searchValInput = this.refs.searchValInput.value;
    this.setState({ loading: true });

    var thisComponent = this;

    $.get("/v1/calls", { name: searchValInput })
      .done(function(response) {
        console.log(response);
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

  all = (e) => {
    e && e.preventDefault();
    this.setState({ loading: true });
    var thisComponent = this;

    $.get("/v1/calls")
      .done(function(data) {
        thisComponent
          .setState({ calls: data.calls, searchVal: '', errorMessage: '', loading: false });
      }).fail(function(data) {
        thisComponent.setState({ errorMessage: App.utils.errorMessage, loading: false });
      });
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
        <form onSubmit={ this.handleSubmit }>
          <div className='form-group'>
            <input id="search_bar"
                   className="form-control mb-2"
                   autoFocus={ true }
                   type='search'
                   required={ true }
                   ref='searchValInput'
                   defaultValue={ this.state.searchVal }
                   placeholder='search...'>
            </input>
          </div>
        </form>

        <div className='gray'>
          { this.state.errorMessage }
        </div>

        <div className='clearfix'>
          { (function() {
            if (thisComponent.state.searchVal) {
              var callCount = thisComponent.state.calls.length;
              return (
                <div>
                  <p className='float-left gray'>{ callCount + pluralize(' call', callCount) }</p>
                  <a id='all_calls' href='/' className='float-right' onClick={ thisComponent.all }>All Calls</a>
                  <div className='clear'></div>
                </div>);
            }
          })() }
        </div>

        <div className='mt-2'>
         { this.state.calls.map(this.renderCall) }
        </div>
      </div>
    );
  }

  renderCall(call) {
    return (
      <a className="card mt-3 rounded-0 text-dark border-top-0 border-left-0 border-right-0 text-decoration-none hover-bg-light" href={ call.path } key={ call.id }>
        <h4 className='card-title'>{ call.name }</h4>
        <div className="card-body p-0">
          { call.application_deadline }
        </div>
      </a>
    );
  }

};