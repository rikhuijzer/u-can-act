import React from 'react'
import Select from './Select'

export default class YearDropdownMenu extends React.Component {
  generateYears() {

    start = 2017;
    end = new Date().getFullYear();
    var years = [];
    for (var i = start; i <= end; i++) {
      years.push(i);
    }
    return (years)
  }

  render() {
    var years = this.generateYears();
    return(
      <Select value={this.props.value} options={years} label='Year' onChange={this.props.onChange} />
    )
  }
}