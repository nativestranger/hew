import React from "react";
import PropTypes from "prop-types";

export default class Pagination extends React.Component {
  static propTypes = {
    pagination: PropTypes.object.isRequired
  }

  render() {
    let thisComponent = this;

    // [1..pagination.pages]
    let pageNumbers = [
      ...Array(this.props.pagination.pages).keys()
    ].map(n => n+1);

    let renderPageNumberLink = function(n) {
      let pageItemClass = "page-item";

      if (thisComponent.props.pagination.current == n) {
        pageItemClass += " active";
      }

      return (
        <li key={n} className={pageItemClass}>
          <a className="page-link" href={`?page=${n}`}>{n}</a>
        </li>
      )
    }

    return (
      <nav className="">
        <ul className="pagination">
          { thisComponent.props.pagination.previous && (
            <li className="page-item">
              <a className="page-link" href="?page=1">« First</a>
            </li>
          ) }

          { thisComponent.props.pagination.previous && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.previous}`}>‹ Prev</a>
            </li>
          ) }

          { pageNumbers.map(n => renderPageNumberLink(n)) }

          <li key="mystery" className="page-item disabled"><a href="#" onClick={function() {return false}} className="page-link">…</a></li>

          { thisComponent.props.pagination.next && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.next}`}>Next ›</a>
            </li>
          ) }

          { thisComponent.props.pagination.next && (
            <li className="page-item">
              <a className="page-link" href={`?page=${this.props.pagination.pages}`}>Last »</a>
            </li>
          ) }
        </ul>
      </nav>
    );
  }
}
