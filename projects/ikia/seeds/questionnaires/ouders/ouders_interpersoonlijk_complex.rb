# frozen_string_literal: true

db_title = 'Sociale omgang'

db_name1 = 'Interpersoonlijk gedrag'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
likert_options = ['Helemaal niet', 'Matig', 'Heel sterk']
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Met deze vragenlijst doet u onderzoek naar uw sociale omgang met anderen. Het invullen kost u minder dan 10 minuten. De onderstaande lijst met vragen gaan over veelvoorkomende problemen tussen mensen. Wilt u aangeven of u ooit hetzelfde heeft gevoeld in uw omgang met belangrijke mensen in uw leven? Het blokje op de antwoordschaal kunt u verschuiven tot de plek die volgens u het beste aansluit bij uw ervaringen. Er zijn geen goede of foute antwoorden. Uw resultaten en de betekenis daarvan kunt u hierna op uw resultatenpagina lezen. Alvast hartelijk dank voor uw hulp en succes met invullen.</p>'
  }, {
    id: :v1a,
    type: :range,
    title: 'Hoe gelukkig bent u?',
    labels: ['Helemaal niet gelukkig', 'Matig gelukkig', 'Heel erg gelukkig'],
    required: true
  }, {
    section_start: 'De onderstaande punten zijn dingen die u als moeilijk ervaart in het contact met anderen. Het is moeilijk voor mij om…',
    id: :v1,
    type: :likert,
    title: '“Nee” te zeggen tegen andere mensen',
    options: likert_options,
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :likert,
    title: 'Mee te doen met een groep',
    options: likert_options,
    required: true
  }, {
    id: :v3,
    type: :likert,
    title: 'Dingen voor mezelf te houden',
    options: likert_options,
    required: true
  }, {
    id: :v4,
    type: :likert,
    title: 'Iemand te zeggen dat hij/zij moet stoppen met me lastig te vallen',
    options: likert_options,
    required: true
  }, {
    id: :v5,
    type: :likert,
    title: 'Mezelf voor te stellen aan nieuwe mensen',
    options: likert_options,
    required: true
  }, {
    id: :v6,
    type: :likert,
    title: 'Andere mensen te wijzen op problemen die zich voordoen',
    options: likert_options,
    required: true
  }, {
    id: :v7,
    type: :likert,
    title: 'Me assertief en zelfbewust op te stellen tegenover iemand anders',
    options: likert_options,
    required: true
  }, {
    id: :v8,
    type: :likert,
    title: 'Anderen duidelijk te maken dat ik kwaad ben',
    options: likert_options,
    required: true
  }, {
    id: :v9,
    type: :likert,
    title: 'Sociaal en gezellig om te gaan met anderen',
    options: likert_options,
    required: true
  }, {
    id: :v10,
    type: :likert,
    title: 'Genegenheid te tonen aan mensen',
    options: likert_options,
    required: true
  }, {
    id: :v11,
    type: :likert,
    title: 'Op te schieten met mensen',
    options: likert_options,
    required: true
  }, {
    id: :v12,
    type: :likert,
    title: 'Vastberaden te zijn als dit nodig is',
    options: likert_options,
    required: true
  }, {
    id: :v13,
    type: :likert,
    title: 'Een gevoel van liefde te ervaren voor iemand anders',
    options: likert_options,
    required: true
  }, {
    id: :v14,
    type: :likert,
    title: 'Iemand anders te ondersteunen in zijn/haar doelen in het leven',
    options: likert_options,
    required: true
  }, {
    id: :v15,
    type: :likert,
    title: 'Een gevoel van hechte verbondenheid te voelen ten aanzien van andere mensen',
    options: likert_options,
    required: true
  }, {
    id: :v16,
    type: :likert,
    title: 'Echt te geven om de problemen van anderen',
    options: likert_options,
    required: true
  }, {
    id: :v17,
    type: :likert,
    title: 'De noden van iemand anders te laten voorgaan op de mijne',
    options: likert_options,
    required: true
  }, {
    id: :v18,
    type: :likert,
    title: 'Me goed te voelen om het geluk van een ander',
    options: likert_options,
    required: true
  }, {
    id: :v19,
    type: :likert,
    title: 'Andere mensen uit te nodigen voor een gezellig samenzijn met mij',
    options: likert_options,
    required: true
  }, {
    id: :v20,
    type: :likert,
    title: 'Assertief te zijn zonder bezorgd te zijn dat ik andermans gevoelens zou kwetsen',
    options: likert_options,
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende zaken doe ik teveel:',
    id: :v21,
    type: :likert,
    title: 'Ik geef mezelf te veel bloot aan anderen',
    options: likert_options,
    required: true,
    section_end: false
  }, {
    id: :v22,
    type: :likert,
    title: 'Ik ben te agressief naar andere mensen',
    options: likert_options,
    required: true
  }, {
    id: :v23,
    type: :likert,
    title: 'Ik probeer andere mensen te veel te behagen',
    options: likert_options,
    required: true
  }, {
    id: :v24,
    type: :likert,
    title: 'Ik wil te veel opvallen',
    options: likert_options,
    required: true
  }, {
    id: :v25,
    type: :likert,
    title: 'Ik probeer andere mensen te veel te controleren',
    options: likert_options,
    required: true
  }, {
    id: :v26,
    type: :likert,
    title: 'Ik stel de noden van andere mensen boven de mijne',
    options: likert_options,
    required: true
  }, {
    id: :v27,
    type: :likert,
    title: 'Ik ben al te vrijgevig naar andere mensen toe',
    options: likert_options,
    required: true
  }, {
    id: :v28,
    type: :likert,
    title: 'Ik manipuleer andere mensen te veel om mijn zin te krijgen',
    options: likert_options,
    required: true
  }, {
    id: :v29,
    type: :likert,
    title: 'Ik vertel te veel persoonlijke zaken aan andere mensen',
    options: likert_options,
    required: true
  }, {
    id: :v30,
    type: :likert,
    title: 'Ik ga te veel in discussie met andere mensen',
    options: likert_options,
    required: true
  }, {
    id: :v31,
    type: :likert,
    title: 'Ik laat andere mensen te veel van mij profiteren',
    options: likert_options,
    required: true
  }, {
    id: :v32,
    type: :likert,
    title: 'Ik word te veel emotioneel getroffen door het leed van een ander',
    options: likert_options,
    required: true,
    section_end: true
  }
]
invert = { multiply_with: -1, offset: 100 }
dagboek1.content = {
  questions: dagboek_content,
  scores: [
    { id: :s1,
      label: 'Boven',
      ids: %i[v11 v22 v25 v30],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s2,
      label: 'Boven-Samen',
      ids: %i[v3 v21 v24 v29],
       operation: :average,
      round_to_decimals: 0 },
    { id: :s3,
      label: 'Samen',
      ids: %i[v1 v23 v26 v32],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s4,
      label: 'Onder-Samen',
       ids: %i[v8 v20 v27 v31],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s5,
      label: 'Onder',
      ids: %i[v4 v6 v7 v12],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s6,
      label: 'Onder-Niet samen',
       ids: %i[v2 v5 v9 v19],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s7,
      label: 'Niet samen',
       ids: %i[v10 v13 v15 v16],
      operation: :average,
      round_to_decimals: 0 },
    { id: :s8,
      label: 'Boven-Niet samen',
      ids: %i[v14 v17 v18 v28],
      operation: :average,
      round_to_decimals: 0 }
    ]
  }
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
