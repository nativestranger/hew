import React from 'react';
import PropTypes from "prop-types";

import {
  Button, Modal, ModalHeader, ModalBody, ModalFooter,
  Form, FormGroup, Label, Input, FormText
} from 'reactstrap';

import SortableComponent from './SortableComponent';

import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default class ManagePieceModal extends React.Component {
  static propTypes = {
    parentComponent: PropTypes.object.isRequired,
    className: PropTypes.string,
    piece: PropTypes.object
  }

  constructor(props) {
    super(props);
    this.toggle = this.toggle.bind(this);
    this.renderForm = this.renderForm.bind(this);
    this.renderModal = this.renderModal.bind(this);
    this.deletePiece = this.deletePiece.bind(this);
    this.updatePiece = this.updatePiece.bind(this);
    this.setPieceImages = this.setPieceImages.bind(this);
  }

  componentWillMount() {
    this.setState({
      modal: false,
      piece: this.props.piece
    });
  }

  toggle() {
    let thisComponent = this;
    let closing = new Boolean(thisComponent.state.modal);

    let updateParent = function() {
      if (closing) {
        // thisComponent.props.parentComponent.pieceChanged(thisComponent.state.piece);
      }
    }

    this.setState({
      modal: !this.state.modal
    }, updateParent);
  }

  updatePiece(e) {
    e.preventDefault();
    let thisComponent = this;

    let pieceData = {
      title: document.getElementById('piece_title').value,
      medium: document.getElementById('piece_medium').value,
      description: document.getElementById('piece_description').value,
      image_ids_in_position_order: document.getElementById('piece_image_ids_in_position_order').value,
    }

    let makeRequest = function() {
      return axios({
        method: 'patch',
        url: `/v1/pieces/${thisComponent.state.piece.id}`,
        data: {
          entry_id: thisComponent.props.entry_id,
          piece: pieceData
        },
        config: { headers: { 'Content-Type': 'application/json' } }
      });
    };

    makeRequest().then(response => {
      // set state on child? - ensure we can update parent with same values...

      thisComponent.setState({
        errors: response.data.errors,
        piece: response.data.piece
      }, this.toggle);
    }).catch(error => {
      alert(`Something went wrong: ${error}`);
    });
  }

  deletePiece() {
    let thisComponent = this;

    let deleteRequest = () => {
      return axios({
        method: 'delete',
        url: `/v1/pieces/${this.state.piece.id}`
      });
    }

    deleteRequest().then(response => {
      thisComponent.toggle();
      thisComponent.props.parentComponent.pieceRemoved(this.state.piece.id);
    }).catch(error => {
      alert(`Something went wrong: ${error}`);
    });
  }



  renderForm() {
    let thisComponent = this;

    let renderPieceImages = function() {
      return (
        <div>
          <div className="d-none">
            <div className="form-group hidden piece_image_ids_in_position_order">
              <input className="form-control hidden" type="hidden" name="piece[image_ids_in_position_order]" id="piece_image_ids_in_position_order" value="" />
            </div>
          </div>
          <div className='carousel-images'>
            <SortableComponent ref='sortableImages' piece_id={ thisComponent.state.piece.id } items={ thisComponent.state.piece.piece_images } helperClass='modal-sortable' />
          </div>
        </div>
      );
    }

    return (
      <Form>
        <FormGroup>
          <Label for="piece_title">Title</Label>
          <Input type="string" name="title" id="piece_title" placeholder="" defaultValue={ this.state.piece.title } />
        </FormGroup>
        <FormGroup>
          <Label for="piece_title">Medium</Label>
          <Input type="string" name="medium"  id="piece_medium" placeholder="" defaultValue={ this.state.piece.medium } />
        </FormGroup>
        <FormGroup>
          <Label for="piece_description">Description</Label>
          <div className='row'>
            <div className="col-lg-12">
              <input id={ 'piece_description' } defaultValue={ this.state.piece.description } type="hidden"/>
              <trix-editor input={ 'piece_description' }></trix-editor>
            </div>
          </div>
        </FormGroup>
        { this.state.piece.id && renderPieceImages() }
      </Form>
    );
  }

  setPieceImages() {
    // TODO: only if added/deleted AND NOT reordered without save??...
    // OR set child state before closing and setting this state to ensure parent has new order?...

    // let piece = Object.assign({}, this.state.piece);
    // piece.piece_images = this.refs.sortableImages.state.pieceImages.sort(
    //   function(a, b) { return a.position - b.position; }
    // );
    // this.setState({ piece: piece });
  }

  renderModal() {
    return (
      <Modal isOpen={this.state.modal} onClosed={this.setPieceImages} size='lg' toggle={this.toggle} className={this.props.className}>
        <ModalHeader toggle={this.toggle}>Manage Piece</ModalHeader>
        <ModalBody>
          { this.renderForm() }
        </ModalBody>
        <ModalFooter className='d-flex justify-content-between'>
          <Button color="primary" onClick={this.updatePiece}>Save</Button>

          <Button color="danger" onClick={this.deletePiece}>Delete</Button>
        </ModalFooter>
      </Modal>
    );
  }

  render() {
    if (this.state.piece.id) {
      return (
        <div key={this.state.piece.id} className="col-md-2 mb-4 piece">
          <h6 onClick={this.toggle}>
            { this.state.piece.title || 'Untitled' }
          </h6>
          <div onClick={this.toggle}>
            { this.state.piece.piece_images[0] && (
              <img className="img-fluid" src={ this.state.piece.piece_images[0].src } />
            ) }
            { !this.state.piece.piece_images[0] && (
              <i className='fa fa-image fa-5x p-4 border'></i>
            ) }
          </div>
          { this.renderModal() }
        </div>
      );
    } else {
      return this.renderModal();
    }
  }
};
