describe("MentorRewardPage", function() {
  beforeEach(function() {
    var component = React.createElement(MentorRewardPage, {});
    this.rendered = TestUtils.renderIntoDocument(component)
  });
  
  it("it should return the correct text", function() {
    var elems = ReactDOM.findDOMNode(this.rendered).children;
    var expected = 'Heel erg bedankt voor je inzet voor dit onderzoek!';
    var result = elems[0].innerText;
    expect(result).toEqual(expected);

    var expected = 'Hartelijke groeten van het u-can-act team.';
    var result = elems[1].innerText;
    expect(result).toEqual(expected);

    var expected = 'Je kan deze pagina veilig sluiten.';
    var result = elems[2].innerText;
    expect(result).toEqual(expected);
  });
});
