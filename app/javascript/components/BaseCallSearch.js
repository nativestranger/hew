import React from "react";
import PropTypes from "prop-types";
import Pagination from "./Pagination";

export default class BaseCallSearch extends React.Component {

  constructor(props) {
    super(props);
    this.currentPage = this.currentPage.bind(this);
    this.toggleCallType = this.toggleCallType.bind(this);
    this.selectedCallTypes = this.selectedCallTypes.bind(this);
    this.selectedOrderOption = this.selectedOrderOption.bind(this);
    this.renderSortByDropdown = this.renderSortByDropdown.bind(this);
    this.renderCallTypeDropdown = this.renderCallTypeDropdown.bind(this);
    this.setLocalStorageFilters = this.setLocalStorageFilters.bind(this);
  }

  // TODO: display pagination or reset page when results returned that make our current page # greater than pages returned
  currentPage() {
    return (this.state.pagination && this.state.pagination.current) || this.props.page;
  }

  setLocalStorageFilters(property, value) {
    // TODO: determine when/if
  }

  selectedCallTypes() {
    return this.state.call_types.filter(type => type.selected);
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
      thisComponent.setState({ orderOptions: orderOptions }, function() {
        thisComponent.setLocalStorageFilters('orderOptions', orderOptions);
      });
      thisComponent.getCalls();
    }

    return (
      <div className="hover-dropdown d-inline">
          <button className="hover-dropbtn btn btn-sm btn-light" type="button" data-toggle="dropdown">{this.selectedOrderOption().name}
          <span className="caret"></span></button>
          <div className="hover-dropdown-content dropdown-menu-right text-center">
            { thisComponent.state.orderOptions.map(orderOption => {
              return (
                <div key={orderOption.name} className="dropdown-item c-pointer d-flex justify-content-start" onClick={ function(e) { e.preventDefault(); selectOrderOption(orderOption.name) } }>
                  { isSelected(orderOption.name) && <strong>{orderOption.name}</strong> }
                  { !isSelected(orderOption.name) && <span>{orderOption.name}</span> }
                </div>
              )
            }) }
          </div>
      </div>
    );
  }

  toggleCallType(callType) {
    let thisComponent = this;

    let call_types = [...this.state.call_types];
    callType = call_types.find(type => type.name === callType);
    callType.selected = !callType.selected;
    this.setState({ call_types: call_types }, function() {
      thisComponent.setLocalStorageFilters('call_types', call_types);
    });
    this.getCalls();
  }

  renderCallTypeDropdown() {
    let thisComponent = this;

    let isSelected = function(callTypeName) {
      return thisComponent.selectedCallTypes().find(type => type.name === callTypeName);
    }

    return (
      <div className="hover-dropdown">
        <button className="hover-dropbtn btn btn-sm btn-light">Call Types</button>

        <div className="hover-dropdown-content">
          { this.props.call_types.map(function(callType) {
            return (
              <div key={callType.name} className="dropdown-item c-pointer d-flex justify-content-between" onClick={ function() { thisComponent.toggleCallType(callType.name) } }>
                <span>{callType.name}</span>
                { isSelected(callType.name) && <span className="fa fa-check fa-sm p-2 text-success mb-1"></span> }
                { !isSelected(callType.name) && <span className="fa fa-times fa-sm p-2 text-danger mb-1"></span> }
              </div>
            );
          }) }
        </div>
      </div>
    );
  }

}
