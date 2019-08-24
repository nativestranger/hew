import React, {Component} from 'react';
import {render} from 'react-dom';
import {SortableContainer, SortableElement} from 'react-sortable-hoc';
import arrayMove from 'array-move';
import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

const SortableItem = SortableElement(({value}) => <li>{value}</li>);

const SortableList = SortableContainer(({items}) => {
  return (
    <ul>
      {items.map((value, index) => (
        <SortableItem key={`item-${index}`} index={index} value={value} />
      ))}
    </ul>
  );
});

export default class SortableComponent extends Component {
  renderItem = (item) => {
    return (
      <div className="sortable-carousel-image" img_id={ item.id }>
        <img className="img-thumbnail" src={ item.src } />
      </div>
    )
  };
  state = {
    items: this.props.items.map(this.renderItem),
    carouselImageObjects: this.props.items,
  };
  onSortEnd = ({oldIndex, newIndex}) => {
    this.setState(({items, carouselImageObjects}) => ({
      items: arrayMove(items, oldIndex, newIndex),
      carouselImageObjects: arrayMove(carouselImageObjects, oldIndex, newIndex),
    }));
  };

  openfileUploader = (e) => {
    this.refs.fileUploader.click();
  };

  addCarouselImage = (formData) => {
    return axios({
      method: 'post',
      url: `/v1/carousels/${this.props.carousel_id}/carousel_images`,
      data: formData,
      config: { headers: {'Content-Type': 'multipart/form-data' }}
    });
  };

  handleFileUpload = (e) => {
    this.setState({ file: e.target.files[0] });

    let formData = new FormData();
    formData.append('image', e.target.files[0], e.target.files[0].name)

    this.addCarouselImage(formData).then(response => {
      this.setState({ file: undefined });
      let carouselImageObjects = [...this.state.carouselImageObjects, response.data.carousel_image];
      this.setState({
        carouselImageObjects: carouselImageObjects,
        items: carouselImageObjects.map(this.renderItem),
      });
    }).catch(error => {
      alert(`Something went wrong: ${error}`);
    });
  }

  uploadBoxOrSpinner = () => {
    if (this.state.file) {
      return (
        <div className='col-lg-2'>
          <div className='loader'></div>
        </div>
      )
    } else if(this.props.carousel_id) {
      return (
        <div className='col-lg-2'>
          <figure className="upload-carousel-img" onClick={this.openfileUploader}>
            <input type="file" onChange={this.handleFileUpload} ref="fileUploader" style={{display: "none"}}/>
            <img src="https://www.flaticon.com/premium-icon/icons/svg/1582/1582582.svg" className="figure-img img-fluid rounded" alt="A generic square placeholder image with rounded corners in a figure." />
          </figure>
        </div>
      )
    }
  }

  render() {
    let thisComponent = this;

    let imagesByPosition = this.state.items.map(i => i.props.img_id)
    document.getElementById('carousel_image_ids_in_position_order').value = imagesByPosition

    return (
      <div className='row'>
        <div className='col-lg-10'>
          <SortableList items={this.state.items} onSortEnd={this.onSortEnd} helperClass={this.props.helperClass} axis='xy' />
        </div>
        { this.uploadBoxOrSpinner() }
      </div>
    )
  }
};
