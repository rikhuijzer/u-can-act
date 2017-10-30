class RewardMessage extends React.Component {
  render() {
    return (
      <div className='section'>
        <p className="flow-text"> Je hebt hiermee {printAsMoney(this.props.euroDelta)} verdiend.
      Je hebt nu in totaal <strong>{printAsMoney(this.props.earnedEuros)}</strong></p>
      </div>
    )
  }
}