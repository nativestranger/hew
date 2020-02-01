import React from "react";
import PropTypes from "prop-types";
import Pagination from "./Pagination";
import InputRange from 'react-input-range';
import 'react-input-range/lib/css/index.css';

export default class BaseCallSearch extends React.Component {

  constructor(props) {
    super(props);
    this.currentPage = this.currentPage.bind(this);
    this.toggleCallType = this.toggleCallType.bind(this);
    this.selectedCallTypes = this.selectedCallTypes.bind(this);
    this.toggleSpider = this.toggleSpider.bind(this);
    this.selectedSpiders = this.selectedSpiders.bind(this);
    this.selectedOrderOption = this.selectedOrderOption.bind(this);
    this.renderSortByDropdown = this.renderSortByDropdown.bind(this);
    this.renderCallTypeDropdown = this.renderCallTypeDropdown.bind(this);
    this.callSearchOptions = this.callSearchOptions.bind(this);
    this.renderDateTimePicker = this.renderDateTimePicker.bind(this);
    this.dateTimePickerValue = this.dateTimePickerValue.bind(this);
    this.toggleFilterButton = this.toggleFilterButton.bind(this);
    this.toggleFilterExpansion = this.toggleFilterExpansion.bind(this);
    this.renderCallTypeFilterMaybe = this.renderCallTypeFilterMaybe.bind(this);
    this.renderSpiderFilterMaybe = this.renderSpiderFilterMaybe.bind(this);
    this.renderEntryFeeFilterMaybe = this.renderEntryFeeFilterMaybe.bind(this);
    this.setLocalStorageFilters = this.setLocalStorageFilters.bind(this);
  }

  componentWillMount() {
    this.setState({
      activeFilterSection: 'call_types'
    });
  }

  // TODO: display pagination or reset page when results returned that make our current page # greater than pages returned
  currentPage() {
    return (this.state.pagination && this.state.pagination.current) || this.props.page;
  }

  toggleFilterExpansion() {
    this.setState({ filterExpanded: !this.state.filterExpanded });
  }

  toggleFilterButton() {
    return (
      <div className='btn btn-sm btn-light border c-pointer' onClick={ this.toggleFilterExpansion }>
        { `${ this.state.filterExpanded ? 'Hide' : 'Show' }` } Filters
      </div>
    );
  }

  setLocalStorageFilters(property, value) {
    // TODO: determine when/if
  }

  selectedSpiders() {
    if (this.state.spiders) {
      return this.state.spiders.filter(spider => spider.selected);
    } else {
      return [];
    }
  }

  selectedCallTypes() {
    if (this.state.call_types) {
      return this.state.call_types.filter(type => type.selected);
    } else {
      return [];
    }
  }

  selectedOrderOption() {
    return this.state.orderOptions.find(option => option.selected);
  }

  renderSortByDropdown() {
    let thisComponent = this;

    let isSelected = function(orderOptionName) {
      return thisComponent.selectedOrderOption().name == orderOptionName;
    }

    let selectOrderOption = function(orderOptionName) {
      let orderOptions = [...thisComponent.state.orderOptions];
      orderOptions.forEach(option => {
        if (option.name === orderOptionName) {
          option.selected = true;
        } else {
          option.selected = false;
        }
      });
      thisComponent.setState({ orderOptions: orderOptions }, function() {
        thisComponent.setLocalStorageFilters('orderOptions', orderOptions);
      });
      thisComponent.getCalls();
    }

    return (
      <div className="hover-dropdown d-inline">
          <span className="hover-dropbtn c-pointer">Sort by {this.selectedOrderOption().name}
          </span>
          <div className="hover-dropdown-content dropdown-menu-right text-center">
            { thisComponent.state.orderOptions.map(orderOption => {
              return (
                <div key={orderOption.name} className="dropdown-item c-pointer d-flex justify-content-start" onClick={ function(e) { e.preventDefault(); selectOrderOption(orderOption.name) } }>
                  { isSelected(orderOption.name) && <strong>{orderOption.name}</strong> }
                  { !isSelected(orderOption.name) && <span>{orderOption.name}</span> }
                </div>
              )
            }) }
          </div>
      </div>
    );
  }

  toggleCallType(name) {
    let thisComponent = this;

    let call_types = [...this.state.call_types];
    let callType = call_types.find(type => type.name === name);
    callType.selected = !callType.selected;
    this.setState({ call_types: call_types }, function() {
      thisComponent.setLocalStorageFilters('call_types', call_types);
    });
    this.getCalls();
  }

  renderCallTypeDropdown() {
    let thisComponent = this;

    let isSelected = function(callTypeName) {
      return thisComponent.selectedCallTypes().find(type => type.name === callTypeName);
    }

    return (
      <div className="hover-dropdown">
        <button className="hover-dropbtn btn btn-sm btn-light">Call Types</button>

        <div className="hover-dropdown-content">
          { this.props.call_types.map(function(callType) {
            return (
              <div key={callType.name} className="dropdown-item c-pointer d-flex justify-content-between" onClick={ function() { thisComponent.toggleCallType(callType.name) } }>
                <span>{callType.name}</span>
                { isSelected(callType.name) && <span className="fa fa-check fa-sm p-2 text-success mb-1"></span> }
                { !isSelected(callType.name) && <span className="fa fa-times fa-sm p-2 text-danger mb-1"></span> }
              </div>
            );
          }) }
        </div>
      </div>
    );
  }

  toggleSpider(name) {
    let thisComponent = this;

    let spiders = [...this.state.spiders];
    let spider = spiders.find(spider => spider.name === name);
    spider.selected = !spider.selected;
    this.setState({ spiders: spiders }, function() {
      thisComponent.setLocalStorageFilters('spiders', spiders);
    });
    this.getCalls();
  }

  renderSpiderDropdown() {
    let thisComponent = this;

    let isSelected = function(spiderName) {
      return thisComponent.selectedSpiders().find(spider => spider.name === spiderName);
    }

    return (
      <div className="hover-dropdown">
        <button className="hover-dropbtn btn btn-sm btn-light">Site</button>

        <div className="hover-dropdown-content">
          { this.props.spiders.map(function(spider) {
            return (
              <div key={spider.name} className="dropdown-item c-pointer d-flex justify-content-between" onClick={ function() { thisComponent.toggleSpider(spider.name) } }>
                <span>{spider.name}</span>
                { isSelected(spider.name) && <span className="fa fa-check fa-sm p-2 text-success mb-1"></span> }
                { !isSelected(spider.name) && <span className="fa fa-times fa-sm p-2 text-danger mb-1"></span> }
              </div>
            );
          }) }
        </div>
      </div>
    );
  }

  callSearchOptions() {
    let searchValInput = this.refs.searchValInput && this.refs.searchValInput.value;

    // pagination should set all of this to localStorage except token, page
    let options = {
      authenticity_token: App.getMetaContent("csrf-token"),
      call_name: searchValInput,
      page: this.currentPage(),
      call_type_ids: this.selectedCallTypes().map(type => type.id),
      spiders: this.selectedSpiders().map(spider => spider.id),
      order_option: this.selectedOrderOption(),
      entry_deadline_start: this.dateTimePickerValue({ id: 'entry_deadline_start' }),
      start_at_start: this.dateTimePickerValue({ id: 'start_at_start' }),
      entry_fee_start: this.state.entry_fee_range && (this.state.entry_fee_range.min * 100),
      entry_fee_end: this.state.entry_fee_range && (this.state.entry_fee_range.max * 100),
     }

    return options;
  }

  // need alt formats
  dateTimePickerValue(opts) {
    if ($(`#${opts['id']}`)[0] && $(`#${opts['id']}`).data('datetimepicker')) {
      let datetimepicker = $(`#${opts['id']}`).data('datetimepicker')
      return datetimepicker.date() && datetimepicker.date().format('YYYY-MM-DDTHH:mm')
    }
  }

  renderFilters(opts) {
    let thisComponent = this;

    let className;
    if (opts.hidden) {
      className = 'd-none'
    } else {
      className = ''
    }

    let selectFilterSection = function(name) {
      thisComponent.setState({ activeFilterSection: name });
    }

    let renderDateFilters = function() {
      let className;
      if (thisComponent.state.activeFilterSection == 'dates') {
        className = 'row'
      } else {
        className = 'd-none' // jquery stored value
      }

      return (
        <div className={className}>
          <div className='col-md-3'>
            { thisComponent.renderDateTimePicker('entry_deadline_start', 'Deadline After') }
          </div>
          <div className='col-md-3'>
            { thisComponent.renderDateTimePicker('start_at_start', 'Event Starts After') }
          </div>
        </div>
      )
    }

    return (
      <div className={className}>
        <div className='row'>
          <div className='col-12'>
            <div className=''>
              <nav className="nav nav-tabs">
                <div className={ `nav-item nav-link c-pointer ${ (this.state.activeFilterSection == 'call_types' ? 'active' : '') }` } onClick={function(){ selectFilterSection('call_types') }}>
                  Call Types
                </div>
                { this.state.spiders && (
                  <div className={ `nav-item nav-link c-pointer ${ (this.state.activeFilterSection == 'spiders' ? 'active' : '') }` } onClick={function(){ selectFilterSection('spiders') }}>
                    Site
                  </div>
                ) }
                <div className={ `nav-item nav-link c-pointer ${ (this.state.activeFilterSection == 'dates' ? 'active' : '') }` } onClick={function(){ selectFilterSection('dates') }}>
                  Dates
                </div>
                <div className={ `nav-item nav-link c-pointer ${ (this.state.activeFilterSection == 'entry_fee' ? 'active' : '') }` } onClick={function(){ selectFilterSection('entry_fee') }}>
                  Entry Fee
                </div>
              </nav>
            </div>
          </div>
        </div>
        <div className='row'>
          <div className='col mb-4'>
            { renderDateFilters() }
            { this.renderCallTypeFilterMaybe() }
            { this.renderSpiderFilterMaybe() }
            { this.renderEntryFeeFilterMaybe() }
          </div>
        </div>
      </div>
    );
  }

  renderCallTypeFilterMaybe() {
    let thisComponent = this;

    if (this.state.activeFilterSection != 'call_types') {
      return;
    }

    let renderCallType = function(callType) {
      return (
        <div key={callType.name} className="m-4 c-pointer" onClick={function() {thisComponent.toggleCallType(callType.name)}}>
          <input className="form-check-input boolean optional c-pointer"
                 checked={callType.selected}
                 onChange={function() {}}
                 type="checkbox" />
          <span>{callType.name}</span>
        </div>
      )
    }

    return (
      <div className='d-md-flex'>
        { this.state.call_types.map(renderCallType) }
      </div>
    )
  }

  renderSpiderFilterMaybe() {
    let thisComponent = this;

    if (this.state.activeFilterSection != 'spiders') {
      return;
    }

    let renderSpider = function(spider) {
      return (
        <div key={spider.name} className="m-4 c-pointer" onClick={function() {thisComponent.toggleSpider(spider.name)}}>
          <input className="form-check-input boolean optional c-pointer"
                 checked={spider.selected}
                 onChange={function() {}}
                 type="checkbox" />
          <span>{spider.name}</span>
        </div>
      )
    }

    return (
      <div className='d-md-flex'>
        { this.state.spiders.map(renderSpider) }
      </div>
    )
  }

  renderEntryFeeFilterMaybe() {
    let thisComponent = this;

    if (this.state.activeFilterSection != 'entry_fee') {
      return;
    }

    // TODO: local storage write
    let updateEntryRange = function(value) {
      thisComponent.setState({ entry_fee_range: value });
    }

    return (
      <div className='p-2 mt-4'>
        <InputRange
          formatLabel={value => `${value} $`}
          maxValue={100}
          minValue={0}
          value={this.state.entry_fee_range || { min: 0, max: 100 }}
          onChange={updateEntryRange}
          onChangeComplete={function() { thisComponent.getCalls(); }} />
      </div>
    )
  }

  renderFilterSection() {
    return (
      <div>
        { this.renderFilters({ hidden: !this.state.filterExpanded }) }
      </div>
    );
  }

  renderDateTimePicker(attribute_name, label) {
    let thisComponent = this;

    let date = this.dateTimePickerValue({ id: attribute_name });
    let visibility_toggle_name = `show_filter__${attribute_name}`;
    let inputID = `${ attribute_name }`;

    let renderControlledInputMaybe = function() {
      if (thisComponent.state[visibility_toggle_name]) {
        return;
      }

      let showjQuerySelector = function() {
        let stateChanges = {};
        stateChanges[visibility_toggle_name] = true;
        thisComponent.setState(stateChanges);
        setTimeout(function() {
          $(`#${ inputID }`).datetimepicker({
                icons: {
                    time: "fa fa-clock-o",
                    date: "fa fa-calendar",
                    up: "fa fa-arrow-up",
                    down: "fa fa-arrow-down",
                    previous: 'fa fa-arrow-left',
                    next: 'fa fa-arrow-right',
                    today: 'fa fa-calendar-o',
                    clear: 'fa fa-times-circle'
                },
                buttons: {
                  // showClear: true
                }
            });

          $(`#${ inputID }`).click(function() {
            $(`#${ inputID }`).datetimepicker('show');
          });

          $(`#${ inputID }`).blur(function() {
            $(`#${ inputID }`).datetimepicker('hide');
          });

          $(`#${ inputID }`).datetimepicker('toggle');
        }, 20);
      }

      return (
        <input className="form-control optional"
               id={ `call_search_${ attribute_name }_initial` }
               defaultValue={ date && moment(date).format('MM/DD/YYYY h:mm A') }
               onMouseEnter={ showjQuerySelector } />
      );
    }

    let renderjQueryInput = function() {
      let style;
      if (!thisComponent.state[visibility_toggle_name]) {
        style = { display: 'none' };
      } else {
        style = {  };
      }

      return (
        <input className="form-control datetime_local optional"
               style={ style }
               type="text" html5="false"
               id={ inputID }
               defaultValue={ moment(date).format('MM/DD/YYYY h:mm A') }
               autoComplete="off" />
      )
    }

    // TODO: generalize
    return (
      <div>
        <div className="form-group datetime_local optional">
          <label className="col-form-label datetime_local optional">{label}</label>

          { renderControlledInputMaybe() }
          { renderjQueryInput() }
        </div>
      </div>
    );
  }
}
