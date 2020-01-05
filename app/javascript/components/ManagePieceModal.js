import React, { useState } from 'react';

import {
  Button, Modal, ModalHeader, ModalBody, ModalFooter,
  Form, FormGroup, Label, Input, FormText
} from 'reactstrap';

import SortableComponent from './SortableComponent';

const ManagePieceModal = (props) => {
  const {
    buttonLabel,
    className
  } = props;

  const [modal, setModal] = useState(false);

  const toggle = () => setModal(!modal);

  const renderForm = function() {
    return (
      <Form>
        <FormGroup>
          <Label for="piece_title">Title</Label>
          <Input type="string" name="title" id="piece_title" placeholder="" />
        </FormGroup>
        <FormGroup>
          <Label for="piece_title">Medium</Label>
          <Input type="string" name="medium" id="piece_medium" placeholder="" />
        </FormGroup>
        <FormGroup>
          <Label for="piece_description">Description</Label>
          <div className='row'>
            <div className="col-lg-12">
              <input id={ 'piece_description' } defaultValue={ '' } type="hidden"/>
              <trix-editor input={ 'piece_description' }></trix-editor>
            </div>
          </div>
        </FormGroup>
        <div>
          <div className="d-none">
            <div className="form-group hidden piece_image_ids_in_position_order">
              <input className="form-control hidden" type="hidden" name="piece[image_ids_in_position_order]" id="piece_image_ids_in_position_order" value="" />
            </div>
          </div>
          <SortableComponent piece_id={ 4 } items={ [] } />
        </div>
        <Button>Submit</Button>
      </Form>
    );
  }

  return (
    <div>
      <Button size="sm" color="primary" onClick={toggle}>{buttonLabel}</Button>
      <Modal isOpen={modal} toggle={toggle} className={className}>
        <ModalHeader toggle={toggle}>Manage Piece</ModalHeader>
        <ModalBody>
          { renderForm() }
        </ModalBody>
        <ModalFooter>
          <Button color="primary" onClick={toggle}>Done</Button>{' '}
          <Button color="danger" onClick={toggle}>Delete</Button>
        </ModalFooter>
      </Modal>
    </div>
  );
}

export default ManagePieceModal;
