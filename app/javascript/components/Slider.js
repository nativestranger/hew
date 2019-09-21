import React from "react";
import PropTypes from "prop-types";
import Slider from "react-slick";
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';
import NextArrow from "./NextArrow";
import PreviousArrow from "./PreviousArrow";

export default class SimpleSlider extends React.Component {
  static propTypes = {
    images: PropTypes.array.isRequired
  };

  constructor(props) {
    super(props);
    this.state = Object.assign({}, props);
    this.next = this.next.bind(this);
    this.previous = this.previous.bind(this);
  };

  next() {
    this.refs.slider.slickNext();
  }
  previous() {
    this.refs.slider.slickPrev();
  }

  renderImages() {
    let thisComponent = this;

    let renderImage = function(img) {
      return (
        <a key={ img.id } href={ img.path }>
          <img className='img-fluid' src={ img.src } alt={ img.alt }/>
        </a>
      );
    };

    return this.props.images.map(renderImage);
  };

  render() {
    var settings = {
      arrows: true,
      dots: true,
      centerMode: true,
      centerPadding: 0,
      infinite: true,
      speed: 500,
      slidesToShow: 1,
      slidesToScroll: 1,
      ref: 'slider',
      nextArrow: <NextArrow />,
      prevArrow: <PreviousArrow />
    };

    return (
      <div className='carousel'>
        <Slider {...settings}>
          { this.renderImages() }
        </Slider>
      </div>
    );
  }
};
