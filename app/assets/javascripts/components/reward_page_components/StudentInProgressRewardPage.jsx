class StudentInProgressRewardPage extends React.Component {
  constructor(props) {
    super(props);

    // Find the last non future index
    var percentageStreakIdx = this.props.protocolCompletion.findIndex(elem => (elem.future));
    percentageStreakIdx = percentageStreakIdx === 0 ? 0 : percentageStreakIdx -1;

    let currentStreak = Math.min(this.props.protocolCompletion[percentageStreakIdx].streak, this.props.maxStreak);
    this.inMaxStreak = (currentStreak === this.props.maxStreak);

    this.totalAvailable = this.props.earnedEuros + this.props.awardable;
    this.percentageStreak =  (currentStreak / this.props.maxStreak) * this.totalAvailable;
  }

  render() {
    return (
      <div>
        <RewardMessage euroDelta={this.props.euroDelta} earnedEuros={this.props.earnedEuros} />
        <div>
          <div className='section'>
            <p className='flow-text'> Voortgang van het onderzoek</p>
          </div>
          <div className='section'>
            {this.inMaxStreak ? <Pyro /> : <div/>}
            <ProgressBar euroDelta={this.props.euroDelta}
                         valueEuro={this.props.earnedEuros}
                         currentMultiplier={this.props.currentMultiplier}
                         percentageStreak={this.percentageStreak}
                         awardableEuro={this.props.awardable}
                         totalAvailable={this.totalAvailable}/>
            <ProgressText awardable={this.props.awardable}
                        protocolCompletion={this.props.protocolCompletion} />
          </div>
        </div>
      </div>
    )
  }
}
