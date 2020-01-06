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
    this.createOrUpdate = this.createOrUpdate.bind(this);
  }

  componentWillMount() {
    this.setState({
      modal: false,
      piece: this.props.piece || {}
    });
  }

  toggle() {
    if (this.state.created) {
      this.setState({
        piece: {}
      });
    } // TODO: destructure unless better flow...

    this.setState({
      modal: !this.state.modal
    });
  }

  createOrUpdate(e) {
    e.preventDefault();
    let thisComponent = this;

    let pieceData = {
      title: document.getElementById('piece_title').value,
      medium: document.getElementById('piece_medium').value,
      description: document.getElementById('piece_description').value,
    }

    let updating;

    let makeRequest = function() {
      if (thisComponent.state.piece.id) {
        updating = true;

        return axios({
          method: 'patch',
          url: `/v1/pieces/${thisComponent.state.piece.id}`,
          data: {
            entry_id: thisComponent.props.entry_id,
            piece: pieceData
          },
          config: { headers: { 'Content-Type': 'application/json' } }
        });
      } else {
        return axios({
          method: 'post',
          url: `/v1/pieces`,
          data: {
            entry_id: thisComponent.props.entry_id,
            piece: pieceData
          },
          config: { headers: { 'Content-Type': 'application/json' } }
        });
      }
    }

    makeRequest().then(response => {
      thisComponent.props.parentComponent.pieceChanged(response.data.piece);

      this.setState({
        errors: response.errors,
      });
      this.toggle();
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

    if (confirm("Are you sure?")) {
      deleteRequest().then(response => {
        thisComponent.toggle();
        thisComponent.props.parentComponent.pieceRemoved(this.state.piece.id);
      }).catch(error => {
        alert(`Something went wrong: ${error}`);
      });
    }
  }

  renderForm() {
    let thisComponent = this;

    let renderPieceImages = function() {
      let items = []
      if (thisComponent.state.piece.id) {
        items = thisComponent.state.piece.piece_images;
      }

      return (
        <div>
          <div className="d-none">
            <div className="form-group hidden piece_image_ids_in_position_order">
              <input className="form-control hidden" type="hidden" name="piece[image_ids_in_position_order]" id="piece_image_ids_in_position_order" value="" />
            </div>
          </div>
          <div className='carousel-images'>
            <SortableComponent piece_id={ thisComponent.state.piece.id } items={ items } helperClass='modal-sortable' />
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

  renderModal() {
    return (
      <Modal isOpen={this.state.modal} size='lg' toggle={this.toggle} className={this.props.className}>
        <ModalHeader toggle={this.toggle}>Manage Piece</ModalHeader>
        <ModalBody>
          { this.renderForm() }
        </ModalBody>
        <ModalFooter className='d-flex justify-content-between'>
          { !this.state.piece.id && (
            <Button color="primary" onClick={ this.createOrUpdate }>Add Images</Button>
          ) }

          { this.state.piece.id && (
            <Button color="primary" onClick={this.createOrUpdate} disabled={!this.state.piece.id}>Save</Button>
          ) }

          <Button color="danger" onClick={this.deletePiece} disabled={!this.state.piece.id} >Delete</Button>
        </ModalFooter>
      </Modal>
    );
  }

  render() {
    if (this.state.piece.id) {
      return (
        <div key={this.state.piece.id} className="col-md-2 mb-4 piece">
          <h6 onClick={this.toggle}>
            { this.state.piece.title }
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
      return (
        <div>
          <Button size="sm" color="primary" onClick={this.toggle}>Add a piece</Button>
          { this.renderModal() }
        </div>
      )
    }
  }
};
