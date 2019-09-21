import React, {Component} from 'react';
import {render} from 'react-dom';
import {SortableContainer, SortableElement} from 'react-sortable-hoc';
import arrayMove from 'array-move';
import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

const SortableItem = SortableElement(({value}) => <span>{value}</span>);

const SortableList = SortableContainer(({items}) => {
  return (
    <div className='sortable-list'>
      {items.map((value, index) => (
        <SortableItem key={`item-${index}`} index={index} value={value} />
      ))}
    </div>
  );
});

export default class SortableComponent extends Component {
  renderItem = (item) => {
    let thisComponent = this;

    let deleteCarouselImage = () => {
      return axios({
        method: 'delete',
        url: `/v1/carousels/${this.props.carousel_id}/carousel_images/${item.id}/`
      });
    }

    let removeImage = function(e) {
      if (confirm("This will delete the image for good. Are you sure?")) {
        deleteCarouselImage().then(response => {
          thisComponent.setState({
            carouselImageObjects: thisComponent.state.carouselImageObjects.filter(function(carouselImage) {
              return carouselImage.id != item.id;
            })
          });
        }).catch(error => {
          alert(`Something went wrong: ${error}`);
        });
      }
    }

    return (
      <div className="sortable-carousel-image" img_id={ item.id }>
        { !thisComponent.state.sorting && (
          <i className='fa fa-times' onClick={ removeImage }></i>
        ) }
        <img className="img-thumbnail" src={ item.src } />
      </div>
    )
  };
  state = {
    carouselImageObjects: this.props.items,
  };
  onSortStart = () => {
    this.setState({ sorting: true });
  };
  onSortEnd = ({oldIndex, newIndex}) => {
    this.setState(({items, carouselImageObjects}) => ({
      sorting: false,
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
    } else {
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

    let imagesByPosition = this.state.carouselImageObjects.map(i => i.id);
    document.getElementById('carousel_image_ids_in_position_order').value = imagesByPosition;

    return (
      <div className='row'>
        <div className='col-lg-10'>
          <SortableList items={this.state.carouselImageObjects.map(this.renderItem)}
                        distance={1}
                        onSortStart={this.onSortStart}
                        onSortEnd={this.onSortEnd}
                        helperClass={this.props.helperClass}
                        axis='xy' />
        </div>
        { this.uploadBoxOrSpinner() }
      </div>
    )
  }
};
