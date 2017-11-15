class ProgressBar extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      timer: null,
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
      showStreakText: false,
    });
  }

  calculateInitialValue() {
    var initialValue = this.props.valueEuro
    if (this.props.currentMultiplier > 0) {
      initialValue -= this.props.euroDelta;
      initialValue += this.props.euroDelta / this.props.currentMultiplier;
    }
    return initialValue
  }

  componentWillUnmount() {
    this.clearInterval(this.state.timer);
  }

  performTimerEvent() {
    this.setState({
      radial: this.renderGraph(this.props.valueEuro, this.props.percentageStreak),
      showStreakText: true
    })
    clearInterval(this.state.timer);
  }

  renderGraph(valueEuro, percentageStreak, awardable, totalAvailable) {
    var radial;
    if (this.state.radial) {
      radial = this.state.radial;
      radial.update([percentageStreak, valueEuro]);
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
            function(value) {
              return printAsMoney(value)
            }, 'je kunt nog ' + printAsMoney(awardable) + ' verdienen!'
          ],
          y: -50
        }
      });
    }
    return (radial)
  }

  createStreakText() {
    if (this.state.showStreakText && this.props.currentMultiplier > 1) {
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
      <div className='row'>
        <div className='col m6 push-m3'>
          <div className="progressRadial" />
          {this.createStreakText()}
          <p>Door een technische fout stond hier vorige week een verkeerd bedrag. Onze excuses. Het bedrag dat er nu staat klopt, uitgaande van dat je mee doet aan 35 metingen.</p>
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
