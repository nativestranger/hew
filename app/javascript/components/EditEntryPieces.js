import React from "react";
import PropTypes from "prop-types";
import ManagePieceModal from "./ManagePieceModal";

export default class EditEntryPieces extends React.Component {
  static propTypes = {
    entry_id: PropTypes.number
  };

  constructor(props) {
    super(props);
    this.getPieces = this.getPieces.bind(this);
    this.renderPieces = this.renderPieces.bind(this);
  };

  componentWillMount() {
    this.setState({
      pieces: undefined
    });
  }

  componentDidMount() {
    this.getPieces();
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
                })
        .fail(function(data) {
                thisComponent.setState({ getError: 'Oops, something went wrong.'});
        });
  }

  renderPieces() {
    if (!this.state.pieces) { return; }

    let renderPiece = function(piece) {
      return (
        <div key={piece.id}>
          { piece.title }
        </div>
      )
    }

    return (
      <div>
        { this.state.pieces.map(renderPiece) }
        { this.state.pieces && !this.state.pieces.length && (
          <p className='text-muted'>
            Add one or more pieces to your entry.
          </p>
        ) }

        { <ManagePieceModal buttonLabel='Add a piece' /> }

      </div>
    )
  }

  render() {
    return (
      <div>
        { this.renderPieces() }
      </div>
    );
  }
};
