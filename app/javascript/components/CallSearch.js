import React from "react";
import PropTypes from "prop-types";

export default class CallSearch extends React.Component {
  static propTypes = {
    call_types: PropTypes.array.isRequired,
    call_type_icons: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props);
    this.getCalls = this.getCalls.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.selectedCallTypes = this.selectedCallTypes.bind(this);
  }

  componentWillMount() {
    this.setState({
      call_types: this.props.call_types,
      calls: []
    });
  }

  componentDidMount() {
    this.getCalls();
  }

  getCalls() {
    let thisComponent = this;
    $.get("/v1/public/calls.json",
           { call_type_ids: this.selectedCallTypes().map(call_type => call_type.id),
             authenticity_token: App.getMetaContent("csrf-token") })
        .done(function(data) {
                  console.log(data);
                  thisComponent.setState({ getError: false, calls: data.calls });
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

  selectedCallTypes() {
    return this.state.call_types.filter(type => type.selected);
  }

  render() {
    let thisComponent = this;

    return (
      <div className="call-searcher">
        { this.renderFilterSection() }
        <div className="calls">
          { this.state.calls && this.state.calls.map(call => (
            <div className="row mb-4 mt-2" key={call.id}>
                <div className="col-12 mx-auto">
                    <div className="card border-0">
                        <div className="card-header bg-white border-0 p-0">
                            <div className="row">
                                <div className="col-12">
                                    <h5 className="mb-0">
                                      <span className={ `fa ${this.props.call_type_icons[call.call_type.name] || this.props.call_type_icons['default']} fa-sm p-2` }></span>
                                      <a href="/calls/7/details">{call.name}
                                        { call.venue && (<h6 className="d-inline">@ {call.venue.id}</h6>) }
                                      </a>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div className="card-body my-1 p-0">
                          <p className="mb-0 text-truncate text-muted">{call.overview}</p>
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
            </div>
          )) }
        </div>
	    </div>
    );
  }

  renderFilterSection() {
    let thisComponent = this;

    let renderCallType = function(callType) {
      return (
        <span key={callType.id} className="d-inline badge badge-primary mr-1 c-pointer" onClick={function(){toggleCallType(callType.name)}}>
          {callType.name}
          <span className="fa fa-times fa-sm pl-1"></span>
        </span>
      );
    }

    let isSelected = function(callTypeName) {
      return thisComponent.selectedCallTypes().find(type => type.name === callTypeName);
    }

    let toggleCallType = function(callType) {
      let call_types = [...thisComponent.state.call_types];
      callType = call_types.find(type => type.name === callType);
      callType.selected = !callType.selected;
      thisComponent.setState({ call_types: call_types });
      thisComponent.getCalls();
    }

    return (
      <div className="filters card">
        <div className="search-container p-1">
          { this.selectedCallTypes().map(renderCallType) }
        </div>
        <hr className="m-0"/>
        <div className="dropdowns">
          <div className="dropdown">
              <button className="btn btn-sm btn-muted dropdown-toggle" type="button" data-toggle="dropdown">Call Types
              <span className="caret"></span></button>
              <ul className="dropdown-menu text-center">
                <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); toggleCallType('Exhibition') } }>
                  Exhibitions
                  { isSelected('Exhibition') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
                  { !isSelected('Exhibition') && <span className="fa fa-times fa-sm p-2"></span> }
                </li>
                <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); toggleCallType('Residency') } }>
                  Residencies
                  { isSelected('Residency') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
                  { !isSelected('Residency') && <span className="fa fa-times fa-sm p-2"></span> }
                </li>
                <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); toggleCallType('Publication') } }>
                  Publications
                  { isSelected('Publication') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
                  { !isSelected('Publication') && <span className="fa fa-times fa-sm p-2"></span> }
                </li>
              </ul>
          </div>
        </div>
      </div>
    )
  }
}
