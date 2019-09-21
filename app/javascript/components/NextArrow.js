import React from "react";
import PropTypes from "prop-types";

export default class NextArrow extends React.Component {
  static propTypes = {
    className: PropTypes.string.isRequired,
    style: PropTypes.object.isRequired,
    onClick: PropTypes.func,
  };

  constructor(props) {
    super(props);
  };

  render () {
    return (
      <div className={this.props.className} onClick={this.props.onClick} >
        <i className="arrow right"></i>
      </div>
    );
  }
};
