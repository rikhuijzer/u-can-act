# frozen_string_literal: true
db_title = 'Opvoeding'
db_name1 = 'Opvoeding_Ouderrapportage'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text"> Iedere ouder heeft een eigen aanpak als het om opvoeden gaat. In deze vragenlijst onderzoekt u uw opvoedingsstijl. Er zijn in totaal X vragen. Hier bent u ongeveer X minuten mee bezig. Verplaats het bolletje naar het antwoord dat het beste bij u past. </p>'
  }, {
    id: :v1,
    type: :range,
    title: ' Ik toon genegenheid door mijn kind te knuffelen, te zoenen en vast te houden ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v2,
    type: :range,
    title: 'Als mijn kind zeurt omdat hij/zij iets niet mag, geef ik toe',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Ik ben bang dat mijn kind mij niet meer leuk vindt als ik hem/haar corrigeer voor slecht gedrag. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Ik kibbel met mijn kind.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Ik dreig met straf zonder hier een duidelijke reden voor te geven. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'De straf die ik mijn kind geef hangt af van mijn stemming. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Ik deel warme en intieme momenten met mijn kind.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Ik gil of schreeuw wanneer mijn kind zich misdraagt. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Wanneer ik mijn kind wil straffen als hij/zij zich misdraagt, kan hij/zij mij overhalen om dit niet te doen. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Ik toon respect voor de mening van mijn kind door hem/haar aan te moedigen deze te uiten.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Als mijn kind zijn/haar taken doet laat ik zien dat ik zijn/haar gedrag opmerk. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Ik beëindig de straf van mijn kind vroegtijdig (bijvoorbeeld eerder dan ik had gezegd). ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Ik barst in woede uit tegen mijn kind. ',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Ik geef mijn kind een tik wanneer hij/zij iets verkeerd heeft gedaan.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Als ik iets van mijn kind vraag, geef ik hier een reden voor (bijvoorbeeld: “We gaan over vijf minuten weg dus het is tijd om op te ruimen”).',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v16,
    type: :range,
    title: 'Ik verlies mijn kalmte wanneer mijn kind niet doet wat ik hem/haar gevraagd heb.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Ik moedig mijn kind aan om over zijn/haar problemen te praten.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Als mijn kind doet wat ik hem/haar gevraagd heb geef ik hem/haar een compliment voor het luisteren.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Ik geef mijn kind van tevoren een seintje als we iets anders gaan doen (bijvoorbeeld een waarschuwing dat we over vijf minuten van huis vertrekken).',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'Als mijn kind overstuur raakt wanneer ik hem/haar iets weiger, krabbel ik terug en geef ik toch toe.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'Mijn kind en ik knuffelen elkaar en/of geven elkaar zoenen.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: 'Ik luister naar de ideeën en meningen van mijn kind.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Het is voor mijn gevoel te veel gedoe om mijn kind zover te krijgen dat hij/zij naar mij luistert.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Ik geef mijn kind een tik wanneer ik heel erg boos ben.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Ik gebruik lichamelijke straffen (zoals een tik geven) om mijn kind te corrigeren.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Als mijn kind zijn/haar kamer opruimt laat ik hem/haar weten hoe trots ik ben.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Ik geef toe aan mijn kind als hij/zij ergens heisa over maakt.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Ik vertel mijn kind hoe ik verwacht dat hij/zij zich zal gedragen voordat hij/zij ergens mee bezig gaat.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Wanneer ik overstuur ben of last heb van stress, word ik kritisch en streng tegen mijn kind.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Ik laat mijn kind weten dat ik het fijn vind wanneer hij/zij meehelpt in huis.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Ik gebruik lichamelijke straffen (zoals een tik geven) omdat andere dingen die ik heb geprobeerd niet hebben gewerkt.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Wanneer ik mijn kind corrigeer voor zijn/haar gedrag leg ik kort uit waarom.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Ik vermijd strijd met mijn kind door hem/haar duidelijke keuzes te geven.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Wanneer mijn kind zich misdraagt, laat ik hem/haar weten wat er zal gebeuren als hij/zij zich niet gaat gedragen.',
    labels: ['Nooit', 'Soms', 'Altijd'],
    required: true
  }, {
    section_start: ' De volgende vragen gaan over hoe u de opvoeding en de relatie met uw kind ervaart. Geef voor elke uitspraak aan in hoeverre deze voor u geldt door het bolletje te verplaatsen.',
    id: :v35,
    type: :range,
    title: 'Ik voel me gelukkig met mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true,
    section_end: false
  }, {
    id: :v36,
    type: :range,
    title: 'Door de opvoeding van mijn kind kom ik te weinig aan mezelf toe.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Ik voel me vrolijk als mijn kind bij mij is.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Door mijn kind kom ik weinig toe aan andere dingen.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Ik heb een tevreden gevoel over mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v40,
    type: :range,
    title: 'Ik zou vaker vrienden en kennissen willen bezoeken maar dat gaat niet
vanwege mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v41,
    type: :range,
    title: 'Met mijn kind voel ik me prettig.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v42,
    type: :range,
    title: 'Ik heb vanwege mijn kind minder contact met mijn vrienden dan vroeger.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v43,
    type: :range,
    title: 'Als mijn kind bij mij is voel ik me rustig.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v44,
    type: :range,
    title: 'Ik kan door mijn kind heel weinig van huis weg.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Ik geniet van mijn kind.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Ik heb door mijn kind weinig contacten met andere mensen.',
    labels: ['Geldt niet voor mij', 'Geldt een beetje voor mij', 'Geldt helemaal voor mij'],
    required: true,
    section_end: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!