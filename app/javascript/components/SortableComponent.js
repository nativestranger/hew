import React, {Component} from 'react';
import {render} from 'react-dom';
import {SortableContainer, SortableElement} from 'react-sortable-hoc';
import arrayMove from 'array-move';

const SortableItem = SortableElement(({value}) => <li>{value}</li>);

const SortableList = SortableContainer(({items}) => {
  return (
    <ul>
      {items.map((value, index) => (
        <SortableItem key={`item-${index}`} index={index} value={value} />
      ))}
    </ul>
  );
});

export default class SortableComponent extends Component {
  renderItem = (item) => {
    return (
      <img className="img-thumbnail mh-100" src={ item.src } img_id={ item.id } />
    )
  };
  state = {
    items: this.props.items.map(this.renderItem),
  };
  onSortEnd = ({oldIndex, newIndex}) => {
    this.setState(({items}) => ({
      items: arrayMove(items, oldIndex, newIndex),
    }));
  };
  render() {
    let imagesByPosition = this.state.items.map(i => i.props.img_id)
    document.getElementById('gallery_images_ids_in_position_order').value = imagesByPosition
    return <SortableList items={this.state.items} onSortEnd={this.onSortEnd} helperClass={this.props.helperClass} axis='xy' />;
  }
};
