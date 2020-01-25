import jstz from 'jstz';
import React from "react";
import PropTypes from "prop-types";

export default class TimeZoneSetter extends React.Component {
  static propTypes = {
    elementId: PropTypes.string.isRequired
  };

  constructor(props) {
    super(props);
  }

  componentDidMount() {
    let timeZone = jstz.determine().name();
    document.getElementById(this.props.elementId).value = timeZone;
  }

  render = () => {
    return (
      <div className='d-none'></div>
    );
  }
};
