import React from "react";
import PropTypes from "prop-types";

export default class PreviousArrow extends React.Component {
  static propTypes = {
    className: PropTypes.string,
    style: PropTypes.object,
    onClick: PropTypes.func,
  };

  constructor(props) {
    super(props);
  };

  render () {
    return (
      <div className={this.props.className} onClick={this.props.onClick} >
        <i className="arrow left"></i>
      </div>
    );
  }
};
