class ProgressBar extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      timer: null,
      showStreakDetails: false,
      radial: null
    };
  }

  componentDidMount() {
    let timer = setInterval(this.performTimerEvent.bind(this), 1500);
    let radial = this.renderGraph(
      this.calculateInitialValue(),
      this.props.percentageStreak,
      this.props.awardableEuro,
      this.props.totalAvailable
    )

    this.setState({
      timer: timer,
      radial: radial,
    });
  }

  calculateInitialValue() {
    var initialValue = this.props.valueEuro
    if (this.props.currentMultiplier > 0) {
      initialValue -= this.props.euroDelta;
      var multiplier = (this.props.euroDelta / this.props.currentMultiplier) * this.props.initialMultiplier;
      initialValue += multiplier;
    }
    return initialValue;
  }

  componentWillUnmount() {
    this.clearInterval(this.state.timer);
  }

  performTimerEvent() {
    this.setState({
      radial: this.renderGraph(this.props.valueEuro, this.props.percentageStreak),
      showStreakDetails: this.props.inMaxStreak,
    })
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    var radial;
    if (this.state.radial) {
      radial = this.state.radial;
      radial.update({
        series: [{value: percentageStreak}, {value: valueEuro}]
      });
    } else {
      radial = new RadialProgressChart('.progressRadial', {
        diameter: 250,
        max: totalAvailable,
        round: true,
        series: [{
          labelStart: '\u2605',
          value: percentageStreak,
          color: '#079975'
        }, {
          labelStart: '€',
          value: valueEuro,
          color: '#243a76'
        }, ],
        center: {
          content: ['Je hebt nu',
            function(value, _unused, series) {
              // Only update the label when the euro value is being displayed
              if (series.index == 1) { return printAsMoney(value) }
              return printAsMoney(valueEuro)
            }, 'je kunt nog ' + printAsMoney(awardable) + ' verdienen!'
          ],
          y: -50
        }
      });
    }
    return (radial)
  }

  createStreakText() {
    if (this.state.showStreakDetails && this.props.currentMultiplier > 1) {
      let value = (this.props.euroDelta / this.props.currentMultiplier);
      let defaultValue = value * this.props.initialMultiplier ;
      let currentBonus = this.props.euroDelta - defaultValue ;
      let text = "Doordat je al een aantal vragenlijsten op rij hebt ingevuld, heb je ";
      text += printAsMoney(currentBonus);
      text += " extra verdiend!";
      return (<div className="animated pulse"> {text} </div>)
    }
  }

  render() {
    return (
      <div>
        {this.state.showStreakDetails ? <Pyro /> : <div/>}
        <div className='row'>
          <div className='col m6 push-m3'>
            <div className="progressRadial" />
            {this.createStreakText()}
          </div>
        </div>
      </div>
    )
  }
}

ProgressBar.defaultProps = {
  valueEuro: 0,
  percentageStreak: 0,
  awardableEuro: 0,
  totalAvailable: 0
};
