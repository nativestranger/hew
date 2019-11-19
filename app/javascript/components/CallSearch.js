import React from "react";
import PropTypes from "prop-types";

export default class CallSearch extends React.Component {
  static propTypes = {
    call_types: PropTypes.array.isRequired,
    call_type_icons: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);
    this.getCalls = this.getCalls.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.toggleCallType = this.toggleCallType.bind(this);
    this.selectedCallTypes = this.selectedCallTypes.bind(this);
    this.selectedOrderOption = this.selectedOrderOption.bind(this);
    this.renderSortByDropdown = this.renderSortByDropdown.bind(this);
    this.renderCallTypeDropdown = this.renderCallTypeDropdown.bind(this);
  }

  componentWillMount() {
    this.setState({
      call_types: this.props.call_types,
      calls: [],
      orderOptions: [
        { name: 'Deadline', direction: 'desc', selected: true },
        { name: 'Created', direction: 'asc' },
      ]
    });
  }

  componentDidMount() {
    this.getCalls();
  }

  getCalls() {
    let thisComponent = this;
    $.get("/v1/public/calls.json",
           { call_type_ids: this.selectedCallTypes().map(call_type => call_type.id),
             order_option: this.selectedOrderOption(),
             authenticity_token: App.getMetaContent("csrf-token") })
        .done(function(data) {
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

  selectedOrderOption() {
    return this.state.orderOptions.find(option => option.selected);
  }

  render() {
    let thisComponent = this;

    return (
      <div className="call-searcher">
        { this.renderFilterSection() }

        { this.state.calls && (
          <div>
            <p className="text-muted m-1 text-right">{this.state.calls.length} calls</p>
          </div>
        ) }

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
                                      <a href={`/calls/${call.id}/details`}>{call.name}
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
        <span key={callType.id} className="d-inline badge badge-primary mr-1 c-pointer" onClick={function(){thisComponent.toggleCallType(callType.name)}}>
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

  toggleCallType(callType) {
    let call_types = [...this.state.call_types];
    callType = call_types.find(type => type.name === callType);
    callType.selected = !callType.selected;
    this.setState({ call_types: call_types });
    this.getCalls();
  }

  renderCallTypeDropdown() {
    let thisComponent = this;

    let isSelected = function(callTypeName) {
      return thisComponent.selectedCallTypes().find(type => type.name === callTypeName);
    }

    return (
      <div className="dropdown d-inline">
          <button className="btn btn-sm btn-muted dropdown-toggle" type="button" data-toggle="dropdown">Call Types
          <span className="caret"></span></button>
          <ul className="dropdown-menu text-center">
            <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); thisComponent.toggleCallType('Exhibition') } }>
              Exhibitions
              { isSelected('Exhibition') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
              { !isSelected('Exhibition') && <span className="fa fa-times fa-sm p-2"></span> }
            </li>
            <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); thisComponent.toggleCallType('Residency') } }>
              Residencies
              { isSelected('Residency') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
              { !isSelected('Residency') && <span className="fa fa-times fa-sm p-2"></span> }
            </li>
            <li className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); thisComponent.toggleCallType('Publication') } }>
              Publications
              { isSelected('Publication') && <span className="fa fa-check fa-sm p-2 text-success"></span> }
              { !isSelected('Publication') && <span className="fa fa-times fa-sm p-2"></span> }
            </li>
          </ul>
      </div>
    );
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
          <button className="btn btn-sm btn-muted dropdown-toggle" type="button" data-toggle="dropdown">Sort By {this.selectedOrderOption().name}
          <span className="caret"></span></button>
          <ul className="dropdown-menu text-center">
            { thisComponent.state.orderOptions.map(orderOption => {
              return (
                <li key={orderOption.name} className="dropdown-item c-pointer" onClick={ function(e) { e.preventDefault(); selectOrderOption(orderOption.name) } }>
                  <span className="switch switch-sm">
                    <input type="checkbox" checked={isSelected(orderOption.name)} readOnly={true} className="switch" id="switch-id" />
                    <label htmlFor="switch-id">{orderOption.name}</label>
                  </span>
                </li>
              )
            }) }
          </ul>
      </div>
    );
  }
}
