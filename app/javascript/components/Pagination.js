import React from "react";
import PropTypes from "prop-types";

export default class Pagination extends React.Component {
  static propTypes = {
    pagination: PropTypes.object.isRequired,
    onClick: PropTypes.func,
  }

  render() {
    let thisComponent = this;

    // [1..pagination.pages]
    let pageNumbers = [
      ...Array(this.props.pagination.pages).keys()
    ].map(n => n+1);

    let lastPageNumber = pageNumbers[pageNumbers.length - 1];
    let maxPageNumbers = Math.min(lastPageNumber, 5);
    let startPageNumberIndex = 0;
    if (this.props.pagination.current) {
      startPageNumberIndex = Math.max(0, this.props.pagination.current - 3)
    }

    pageNumbers = pageNumbers.slice(startPageNumberIndex, startPageNumberIndex + maxPageNumbers);

    let renderPageNumberLink = function(n) {
      let pageItemClass = "page-item";

      if (thisComponent.props.pagination.current == n) {
        pageItemClass += " active";
      }

      return (
        <li key={n} className={pageItemClass}>
          <a className="page-link" href={`?page=${n}`} onClick={thisComponent.props.onClick}>{n}</a>
        </li>
      )
    }

    return (
      <nav className="">
        <ul className="pagination">
          { thisComponent.props.pagination.previous && (
            <li className="page-item">
              <a className="page-link" href="?page=1" onClick={thisComponent.props.onClick}>« First</a>
            </li>
          ) }

          { thisComponent.props.pagination.previous && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.previous}`} onClick={thisComponent.props.onClick}>‹ Prev</a>
            </li>
          ) }

          { pageNumbers.map(n => renderPageNumberLink(n)) }

          <li key="mystery" className="page-item disabled"><a href="#" onClick={function() {return false}} className="page-link">…</a></li>

          { thisComponent.props.pagination.next && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.next}`} onClick={thisComponent.props.onClick}>Next ›</a>
            </li>
          ) }

          { thisComponent.props.pagination.next && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.pages}`} onClick={thisComponent.props.onClick}>Last »</a>
            </li>
          ) }
        </ul>
      </nav>
    );
  }
}
