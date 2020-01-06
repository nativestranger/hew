import React from "react";
import PropTypes from "prop-types";
import ManagePieceModal from "./ManagePieceModal";

export default class EditEntryPieces extends React.Component {
  static propTypes = {
    entry_id: PropTypes.number.isRequired
  };

  constructor(props) {
    super(props);
    this.getPieces = this.getPieces.bind(this);
    this.renderPieces = this.renderPieces.bind(this);
    this.pieceRemoved = this.pieceRemoved.bind(this);
    this.pieceChanged = this.pieceChanged.bind(this);
    this.newPieceModal = this.newPieceModal.bind(this);
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
    let existingPiece = this.state.pieces.find(p => p.id === piece.id);
    let pieces = Object.assign([], this.state.pieces);

    let newPieceCallback = function() {
      if (existingPiece) { return }
      // thisComponent.refs[`piece-modal-${piece.id}`].setState({ modal: true });
    }

    if (existingPiece) {
      pieces = this.state.pieces.map(function(somePiece) {
        if (somePiece.id === piece.id) {
          return piece;
        } else {
          return somePiece;
        }
      }); // why not updating?? .. because child is managing it's state..!
    } else {
      // pieces.push(piece);

      pieces = this.state.pieces.map(function(somePiece) {
        if (somePiece.id === undefined) {
          return piece;
        } else {
          return somePiece;
        }
      });
    }

    this.setState({ pieces: pieces }, newPieceCallback);
  }

  newPieceModal() {
    let thisComponent = this;
    let newPiece = { created: false, position: 99 };
    let openNewPieceModal = function() {
      thisComponent.refs["piece-modal-undefined"].setState({ modal: true });
    }
    let pieces = Object.assign([], this.state.pieces);
    pieces.push(newPiece);
    this.setState({ pieces: pieces }, openNewPieceModal);
  }

  getPieces() {
    let thisComponent = this;

    $.get("/v1/pieces.json",
           { entry_id: this.props.entry_id,
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

  renderPieces() {
    if (!this.state.pieces) { return; }
    let thisComponent = this;

    let renderPiece = function(piece) {
      return (
        <ManagePieceModal key={piece.id || 'new'} piece={piece} entry_id={thisComponent.props.entry_id} ref={`piece-modal-${piece.id}`} parentComponent={thisComponent} />
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

        <button className='btn btn-primary' onClick={ this.newPieceModal }>
          Add a piece
        </button>
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
