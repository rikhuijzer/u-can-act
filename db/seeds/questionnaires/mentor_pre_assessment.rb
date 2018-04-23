vm_name1 = 'voormeting mentoren'
voormeting1 = Questionnaire.find_by_name(vm_name1)
voormeting1 ||= Questionnaire.new(name: vm_name1)
voormeting1.key ||= vm_name1.parameterize.underscore
voormeting1.content = [{
                         id: :v1,
                         type: :radio,
                         title: 'Wat is jouw hoogst genoten opleiding?',
                         options: ['Geen opleiding (lagere school of basisonderwijs niet afgemaakt)',
                                   'Lager onderwijs (basisonderwijs, speciaal basisonderwijs)',
                                   'Lager of voorbereidend beroepsonderwijs (zoals LTS, LEAO, LHNO, VMBO)',
                                   'Middelbaar algemeen voortgezet onderwijs (zoals MAVO, (M)ULO, MBO-kort, VMBO-t)',
                                   'Middelbaar beroepsonderwijs of beroepsbegeleidend onderwijs (zoals MBO-lang, MTS, MEAO, BOL, BBL, INAS)',
                                   'Hoger algemeen en voorbereidend wetenschappelijk onderwijs (zoals HAVO, VWO, Atheneum, Gymnasium, HBS, MMS)',
                                   'Hoger beroepsonderwijs (zoals HBO, HTS, HEAO, kandidaats wetenschappelijk onderwijs)',
                                   'Wetenschappelijk onderwijs (universiteit) of hoger']
                       }, {
                         id: :v2,
                         type: :textfield,
                         required: true,
                         title: 'Wat is je geboortejaar?',
                         tooltip: 'Noteer je geboortejaar als volgt: jjjj',
                         placeholder: 'jjjj',
                       }, {
                         id: :v3,
                         type: :textfield,
                         required: true,
                         title: 'Hoeveel jaar heb jij tot nu toe gewerkt in de jongerenbegeleiding?',
                         placeholder: 'bv. 3'
                       }, {
                         id: :v4,
                         type: :textfield,
                         required: true,
                         title: 'Wat is je nationaliteit?',
                         placeholder: 'bv. Nederlandse'
                       }]
voormeting1.title = 'Voormeting begeleiders'
voormeting1.save!
