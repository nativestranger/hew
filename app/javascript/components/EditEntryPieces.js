import React from "react";
import PropTypes from "prop-types";
import ManagePieceModal from "./ManagePieceModal";

import axios from 'axios';

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default class EditEntryPieces extends React.Component {
  static propTypes = {
    entry: PropTypes.object.isRequired,
    next_step: PropTypes.string.isRequired
  };

  constructor(props) {
    super(props);
    this.nextStep = this.nextStep.bind(this);
    this.getPieces = this.getPieces.bind(this);
    this.renderPieces = this.renderPieces.bind(this);
    this.pieceRemoved = this.pieceRemoved.bind(this);
    this.pieceChanged = this.pieceChanged.bind(this);
    this.createNewPiece = this.createNewPiece.bind(this);
  };

  componentWillMount() {
    this.setState({
      pieces: undefined
    });
  }

  componentDidMount() {
    this.getPieces();
  }

  pieceRemoved(pieceId) {
    this.setState({
      pieces: this.state.pieces.filter(function(piece) {
        return piece.id != pieceId;
      })
    });
  }

  pieceChanged(piece) {
    let thisComponent = this;
    let pieces = Object.assign([], this.state.pieces);

    pieces = this.state.pieces.map(function(somePiece) {
      if (somePiece.id === piece.id) {
        return piece;
      } else {
        return somePiece;
      }
    });

    this.setState({ pieces: pieces });
  }

  createNewPiece() {
    let thisComponent = this;
    thisComponent.setState({ creatingPiece: true });

    axios({
      method: 'post',
      url: `/v1/pieces`,
      data: {
        entry_id: thisComponent.props.entry.id,
        piece: { title: null }
      },
      config: { headers: { 'Content-Type': 'application/json' } }
    }).then(response => {
      let piece = response.data.piece;
      let openNewPieceModal = function() {
        thisComponent.refs[`piece-modal-${piece.id}`].setState({ modal: true });
      }
      let pieces = Object.assign([], this.state.pieces);
      pieces.push(piece);
      this.setState({ pieces: pieces, creatingPiece: false }, openNewPieceModal);
    }).catch(error => {
      alert(`Something went wrong: ${error}`);
      this.setState({ creatingPiece: false });
    });
  }

  getPieces() {
    let thisComponent = this;

    $.get("/v1/pieces.json",
           { entry_id: this.props.entry.id,
             authenticity_token: App.getMetaContent("csrf-token") })
        .done(function(data) {
          thisComponent.setState({
            getError: false,
            pieces: data.pieces
          });
        }).fail(function(data) {
          thisComponent.setState({ getError: 'Oops, something went wrong.'});
        });
  }

  nextStep() {
    let thisComponent = this;

    let makeRequest = function() {
      return axios({
        method: 'patch',
        url: `/call_applications/${thisComponent.props.next_step}?call_application_id=${thisComponent.props.entry.id}`,
        data: {
          call_application: { creation_status: thisComponent.props.next_step }
        },
        config: { headers: { 'Content-Type': 'application/json' } }
      });
    }

    makeRequest().then(response => {
      if (response.data.redirectPath) {
        window.location.pathname = response.data.redirectPath;
      } else {
        alert(response.data.errors);
      }
    }).catch(error => {
      alert(error)
    })
  }

  renderPieces() {
    if (!this.state.pieces) { return; }
    let thisComponent = this;

    let renderPiece = function(piece) {
      return (
        <ManagePieceModal key={piece.id} piece={piece} entry_id={thisComponent.props.entry.id} ref={`piece-modal-${piece.id}`} parentComponent={thisComponent} />
      );
    }

    return (
      <div>
        { this.state.pieces && !this.state.pieces.length && (
          <p className='text-muted'>
            Add one or more pieces to your entry.
          </p>
        ) }

        <div className="row mb-4">
          { this.state.pieces.map(renderPiece) }
        </div>

        <div className='row'>
          <div className='col-12 d-flex justify-content-between'>
            <button className='btn btn-primary' disabled={ this.state.creatingPiece } onClick={ this.createNewPiece }>
              Add a piece
            </button>
            <button className='btn btn-primary' disabled={ !this.state.pieces.filter(p => p.piece_images.length).length } onClick={ this.nextStep }>
              Continue
            </button>
          </div>
        </div>
      </div>
    );
  }

  render() {
    return (
      <div>
        { this.renderPieces() }
      </div>
    );
  }
};
