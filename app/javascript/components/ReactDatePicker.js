import React from "react";
import PropTypes from "prop-types";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";

export default class ReactDatePicker extends React.Component {
  static propTypes = {
    startDate: PropTypes.string,
    formFieldId: PropTypes.string.isRequired,
    showTimeSelect: PropTypes.bool.isRequired,
    isClearable: PropTypes.bool.isRequired,
    placeholderText: PropTypes.string,
    invalidInput: PropTypes.bool.isRequired,
  };

  constructor(props) {
    super(props);

    let startDate = '';
    if (props.startDate) { startDate = new Date(props.startDate) }

    this.state = { startDate: startDate };
    document.getElementById(this.props.formFieldId).value = startDate;

    this.handleChange = this.handleChange.bind(this);
    this.dateFormat = this.dateFormat.bind(this);
  }

  handleChange(startDate) {
    this.setState({ startDate: startDate });
    document.getElementById(this.props.formFieldId).value = startDate;
  }

  dateFormat() {
    if (this.props.showTimeSelect) {
      return "MMMM d, yyyy h:mm aa"
    } else {
      return "MMMM d, yyyy"
    }
  }

  render() {
    let propsContainer = {
      className: this.props.formFieldId || ''
    }

    if (this.state.startDate) {
      propsContainer.selected = this.state.startDate
    }

    if (this.props.invalidInput && !this.state.startDate) {
      propsContainer.className += ' is-invalid'
    }

    return (
      <DatePicker
        { ...propsContainer }
        onChange={this.handleChange}
        showTimeSelect={this.props.showTimeSelect}
        isClearable={this.props.isClearable}
        placeholderText={this.props.placeholderText}
        dateFormat={this.dateFormat()}
      />
    );
  }
}
