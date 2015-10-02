var Spinner = React.createClass({
  getInitialState: function() {
    return { num: 0 };
  },
  componentDidMount: function() {
    $.getJSON('/number', function(data) {
      this.setState({ num: data.number });
    }.bind(this));
  },
  render: function() {
    return <button onClick={this.handleClick}>{this.state.num}</button>;
  },
  handleClick: function() {
    this.setState({ num: (this.state.num + 1) });
  }
})
