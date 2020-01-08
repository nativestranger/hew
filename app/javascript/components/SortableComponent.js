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

// TODO: could append + image icon here
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

    let deletePieceImage = () => {
      return axios({
        method: 'delete',
        url: `/v1/pieces/${this.props.piece_id}/piece_images/${item.id}/`
      });
    }

    let removeImage = function(e) {
      if (confirm("This will delete the image for good. Are you sure?")) {
        deletePieceImage().then(response => {
          thisComponent.setState({
            pieceImages: thisComponent.state.pieceImages.filter(function(pieceImage) {
              return pieceImage.id != item.id;
            })
          }, thisComponent.updateParent);
        }).catch(error => {
          alert(`Something went wrong: ${error}`);
        });
      }
    }

    return (
      <div className="sortable-carousel-image" img_id={ item.id }>
        { <i className='fa fa-times delete-icon' onClick={ removeImage }></i> }
        <img className="img-thumbnail" src={ item.src } />
      </div>
    )
  };
  state = {
    pieceImages: this.props.items,
  };
  onSortStart = () => {
    this.setState({ sorting: true });
  };
  onSortEnd = ({oldIndex, newIndex}) => {
    this.setState(({items, pieceImages}) => ({
      sorting: false,
      pieceImages: arrayMove(pieceImages, oldIndex, newIndex),
    }));
  };

  updateParent = () => { // updates when adding/deleting
    this.props.parentComponent && this.props.parentComponent.resetPieceImages();
  }

  openfileUploader = (e) => {
    this.refs.fileUploader.click();
  };

  addPieceImage = (formData) => {
    return axios({
      method: 'post',
      url: `/v1/pieces/${this.props.piece_id}/piece_images`,
      data: formData,
      config: { headers: {'Content-Type': 'multipart/form-data' }}
    });
  };

  handleFileUpload = (e) => {
    let thisComponent = this;
    this.setState({ file: e.target.files[0] });

    let formData = new FormData();
    formData.append('image', e.target.files[0], e.target.files[0].name)

    this.addPieceImage(formData).then(response => {
      this.setState({ file: undefined });
      let pieceImages = [...this.state.pieceImages, response.data.piece_image];
      this.setState({
        pieceImages: pieceImages,
      }, thisComponent.updateParent);
    }).catch(error => {
      alert(`Something went wrong: ${error}`);
    });
  }

  uploadBoxOrSpinner = () => {
    if (this.state.file) {
      return (
        <div className='loader mb-4'></div>
      )
    } else {
      return (
        <div className='carousel-img-upload p-2 w-100 border rounded' onClick={this.openfileUploader}>
          <i className='fa fa-camera fa-2x'></i>
          <p className='mb-0'>Click to add a photo</p>
          <input type="file" onChange={this.handleFileUpload} ref="fileUploader" style={{display: "none"}}/>
        </div>
      )
    }
  }

  componentDidUpdate() {
    if (this.state.pieceImages.length) {
      let imagesByPosition = this.state.pieceImages.map(i => i.id);
      document.getElementById('piece_image_ids_in_position_order').value = imagesByPosition;
    }
  }

  render() {
    let thisComponent = this;

    return (
      <div>
        <div className='row'>
          <div className='col-12 text-center mb-4'>
            { this.uploadBoxOrSpinner() }
          </div>
        </div>

        <div className='row'>
          <div className='col-lg-12'>
            <SortableList items={this.state.pieceImages.map(this.renderItem)}
                          distance={1}
                          onSortStart={this.onSortStart}
                          onSortEnd={this.onSortEnd}
                          helperClass={this.props.helperClass}
                          axis='xy' />
          </div>
        </div>
      </div>
    )
  }
};
