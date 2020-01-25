import React from "react";
import PropTypes from "prop-types";
import Pagination from "./Pagination";

export default class BaseCallSearch extends React.Component {
  setLocalStorageFilters(property, value) {
    // TODO: determine when/if
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
}
