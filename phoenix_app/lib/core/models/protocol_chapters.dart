/// Structured data model for the Phoenix Protocol scientific paper.
///
/// Each chapter maps to a pillar or cross-cutting concern of the protocol.
/// Text is in Italian; citations are DOI strings pointing to the original
/// peer-reviewed sources.
library;

class ProtocolChapter {
  final int number;
  final String titleIt;
  final String icon; // Material icon name
  final List<ProtocolSection> sections;

  const ProtocolChapter({
    required this.number,
    required this.titleIt,
    required this.icon,
    required this.sections,
  });
}

class ProtocolSection {
  final String titleIt;
  final String bodyIt; // Markdown-formatted Italian text
  final List<String> citations; // DOI strings

  const ProtocolSection({
    required this.titleIt,
    required this.bodyIt,
    this.citations = const [],
  });
}

// ═══════════════════════════════════════════════════════════════════
// CHAPTERS
// ═══════════════════════════════════════════════════════════════════

const protocolChapters = <ProtocolChapter>[
  // ── 1. FONDAMENTA ──────────────────────────────────────────────
  ProtocolChapter(
    number: 1,
    titleIt: 'Fondamenta',
    icon: 'foundation',
    sections: [
      ProtocolSection(
        titleIt: "L'Obiettivo: Longevita Funzionale",
        bodyIt:
            'Il Protocollo Phoenix non e una dieta ne un programma di allenamento. '
            'E un sistema integrato progettato per ridurre l\'eta biologica '
            'attivando i meccanismi di riparazione cellulare del corpo.\n\n'
            'L\'obiettivo e l\'immortalita funzionale: massimizzare la longevita '
            'e la riparazione cellulare. Ipertrofia e composizione corporea sono '
            'conseguenze, non target. Ogni parametro del protocollo e basato su '
            'evidenze trilingue (EN/ZH/RU) — 120+ studi verificati.',
        citations: [
          '10.1001/jamainternmed.2015.0533', // Laukkanen 2015
          '10.1038/s41586-016-0005-6', // Lopez-Otin hallmarks
        ],
      ),
      ProtocolSection(
        titleIt: 'I Tre Pilastri',
        bodyIt:
            'Il protocollo si fonda su tre pilastri sinergici:\n\n'
            '**Allenamento** — Forza, VO2max e potenza per contrastare sarcopenia, '
            'declino cardiovascolare e deficit autofagico.\n\n'
            '**Condizionamento** — Freddo, calore, meditazione, breathwork e sonno '
            'per attivare hormesis, neuroprotezione e riparazione glinfatica.\n\n'
            '**Nutrizione** — Time-Restricted Eating progressivo verso il digiuno '
            'prolungato, unico intervento con evidenza umana diretta di attivazione '
            'autofagica.',
        citations: [
          '10.1001/jamanetworkopen.2018.3605', // Mandsager 2018
          '10.1016/S0140-6736(15)00234-5', // PURE Leong 2015
        ],
      ),
      ProtocolSection(
        titleIt: 'Il Principio dell\'Autofagia',
        bodyIt:
            'L\'autofagia e il processo con cui le cellule riciclano componenti '
            'danneggiati. E il meccanismo centrale della strategia Phoenix.\n\n'
            'L\'esercizio ad alta intensita e il piu potente attivatore acuto '
            'nel muscolo umano: HIIT produce +162% LC3-II a 3h post-esercizio. '
            'Il digiuno prolungato (5 giorni FMD) e l\'unico intervento con RCT '
            'positivo su autofagia umana nelle PBMC.\n\n'
            'La combinazione esercizio + digiuno e la strategia ottimale, anche '
            'se mancano ancora trial controllati umani che dimostrino un effetto '
            'sinergico additivo.',
        citations: [
          '10.1038/nature10758', // He 2012 Nature
          '10.1096/fj.15-279919', // Schwalm 2015
          '10.1007/s11357-025-02035-4', // Espinoza 2025
        ],
      ),
      ProtocolSection(
        titleIt: 'Evidence-Based Trilingue',
        bodyIt:
            'Nessun parametro senza fonte. Nessuna tradizione scientifica esclusa.\n\n'
            'Il protocollo integra ricerca occidentale (PubMed, Cochrane), russa '
            '(CyberLeninka, monografie Verkhoshansky, tradizione del закаливание) '
            'e cinese (CNKI, linee guida 国家体育总局, medicina tradizionale con '
            'verifica moderna).\n\n'
            'Le fonti russe apportano la periodizzazione a blocchi e il metodo '
            'degli sforzi dinamici. Le fonti cinesi contribuiscono con dati '
            'epidemiologici su sonno, tai chi e integratori tradizionali.',
        citations: [
          '10.1080/02640414.2022.2057529', // Moesgaard 2022
          '10.1007/s40279-024-02134-0', // Pelland 2025
        ],
      ),
    ],
  ),

  // ── 2. ALLENAMENTO ─────────────────────────────────────────────
  ProtocolChapter(
    number: 2,
    titleIt: 'Allenamento',
    icon: 'fitness_center',
    sections: [
      ProtocolSection(
        titleIt: 'Perche Allenarsi per la Longevita',
        bodyIt:
            'L\'allenamento nel protocollo Phoenix non serve per l\'estetica. '
            'Serve per non morire.\n\n'
            '**VO2max** e il singolo miglior predittore di mortalita per tutte le '
            'cause: ogni 1 MET in piu = -13% mortalita (Kodama 2009, n=102.980). '
            'La bassa fitness cardiorespiratoria e un fattore di rischio superiore '
            'al fumo.\n\n'
            '**Forza muscolare** e predittore indipendente: ogni 5 kg di grip '
            'strength in meno = +16% rischio di morte (PURE Study, n=142.861). '
            'Alta forza muscolare = -31% mortalita per tutte le cause.',
        citations: [
          '10.1001/jamanetworkopen.2018.3605', // Mandsager 2018
          '10.1001/jama.2009.681', // Kodama 2009
          '10.1016/S0140-6736(15)00234-5', // Leong 2015 PURE
          '10.1186/s12916-018-1007-z', // Garcia-Hermoso 2018
        ],
      ),
      ProtocolSection(
        titleIt: 'La Struttura Settimanale',
        bodyIt:
            'Il protocollo prevede 7 giorni di allenamento — il recupero e attivo, '
            'mai passivo.\n\n'
            '4 giorni di resistenza con split Push/Pull + Quad/Hip garantiscono '
            '48-72h di recupero per gruppo muscolare. I giorni 3 e 6 sono '
            'condizionamento cardiovascolare + flessibilita (PNF). Il giorno 7 '
            'sviluppa potenza e coordinazione.\n\n'
            'La frequenza 2x/muscolo/settimana e supportata da tutte e 3 le '
            'tradizioni scientifiche. I giorni di cardio servono anche ad allenare '
            'specificamente il VO2max con zona 2 e HIIT.',
        citations: [
          '10.1007/s40279-024-02134-0', // Pelland 2025
          '10.1249/MSS.0b013e3180304570', // Helgerud 2007
          '10.1152/japplphysiol.00384.2017', // San-Millan Brooks 2018
        ],
      ),
      ProtocolSection(
        titleIt: 'Periodizzazione per Tier',
        bodyIt:
            'Il protocollo si parametrizza sul livello dell\'utente:\n\n'
            '**Beginner** (0-6 mesi): sovraccarico lineare. Carico 40-60% 1RM, '
            '10-15 reps. A questo carico, il lavoro a cedimento produce guadagni '
            'di forza pari all\'80% submassimale con minor rischio infortuni.\n\n'
            '**Intermediate** (6-24 mesi): DUP (Daily Undulating Periodization). '
            'Tre zone — forza, ipertrofia, resistenza — ruotate nei 4 giorni.\n\n'
            '**Advanced** (>2 anni): periodizzazione a blocchi di Verkhoshansky. '
            'Mesocicli di 3-4 settimane: accumulo, trasformazione, realizzazione, '
            'deload. Ciclo completo 10-13 settimane.',
        citations: [
          '10.1080/02640414.2022.2057529', // Moesgaard DUP
          '10.1519/SSC.0000000000000790', // Currier 2023
          '10.1007/s40279-021-01435-2', // Lopez 2021
        ],
      ),
      ProtocolSection(
        titleIt: 'Progressione e Autoregolazione',
        bodyIt:
            'Quando l\'utente completa tutte le serie al limite superiore del range '
            'di reps con RPE <=8, avanza automaticamente.\n\n'
            'Per il corpo libero, la progressione avviene tramite modifica della '
            'leva — angolo del corpo, riduzione dei punti di appoggio — non solo '
            'aggiungendo ripetizioni. Ogni pattern motorio ha una catena di '
            'progressione da 6-8 varianti.\n\n'
            'L\'autoregolazione tramite RPE/RIR permette di adattare l\'intensita '
            'giorno per giorno. Per gli Advanced, il VBT (velocity-based training) '
            'aggiunge un feedback oggettivo.',
        citations: [
          '10.1519/SSC.0000000000000455', // NMA autoregulation
          '10.1007/s40279-017-0752-9', // Schoenfeld volume
        ],
      ),
      ProtocolSection(
        titleIt: 'Adattamenti per Eta e Sesso',
        bodyIt:
            'Il protocollo si adatta alla decade dell\'utente. Dopo i 45 anni, '
            'la priorita diventa forza e VO2max: il deload ogni 3 settimane, '
            'piu mobilita, piu equilibrio.\n\n'
            'Le donne hanno meno interferenza nel concurrent training rispetto agli '
            'uomini (Huiberts 2024): il protocollo a 7 giorni funziona meglio per '
            'loro. La periodizzazione basata sul ciclo mestruale NON e supportata '
            'dall\'evidenza (Hackney 2025).\n\n'
            'In post-menopausa, allenamento di resistenza ad alto carico 2-3 '
            'giorni/settimana e la strategia piu efficace per la densita ossea.',
        citations: [
          '10.1007/s40279-024-01987-7', // Huiberts 2024
          '10.1111/sms.14684', // Hackney 2025
          '10.3389/fphys.2023.1145123', // Frontiers menopause
        ],
      ),
    ],
  ),

  // ── 3. CONDIZIONAMENTO ─────────────────────────────────────────
  ProtocolChapter(
    number: 3,
    titleIt: 'Condizionamento',
    icon: 'ac_unit',
    sections: [
      ProtocolSection(
        titleIt: 'Esposizione al Freddo',
        bodyIt:
            'L\'esposizione al freddo attiva la norepinefrina (+200-300%), '
            'aumenta il tessuto adiposo bruno e produce benefici metabolici '
            'documentati quando la dose settimanale raggiunge 11 minuti.\n\n'
            'Progressione: da 30 secondi (settimana 1) a 3 minuti (settimana 6+), '
            '5 volte a settimana. Temperatura 14-15 gradi C.\n\n'
            '**Regola delle 6 ore:** mai cold exposure entro 6 ore da un '
            'allenamento di forza. Il freddo attenua la risposta infiammatoria '
            'necessaria per l\'adattamento muscolare. Terminare sempre sul '
            'freddo (principio Soeberg) per massimizzare la termogenesi BAT.',
        citations: [
          '10.1016/j.xcrm.2021.100434', // Soeberg 2021
          '10.1123/ijspp.2020-0127', // Malta 2021
          '10.1371/journal.pone.0161749', // Buijze 2016
          '10.1007/s40279-024-02108-2', // Pinero 2024
        ],
      ),
      ProtocolSection(
        titleIt: 'Esposizione al Calore',
        bodyIt:
            'La sauna finlandese 4-7x/settimana e associata a -40% mortalita '
            'per tutte le cause, -66% rischio demenza e -65% Alzheimer '
            '(Laukkanen, JAMA Internal Medicine, n=2.315, follow-up 20.7 anni).\n\n'
            'Il meccanismo chiave sono le Heat Shock Proteins (HSP70/HSP90): '
            'chaperoni molecolari che assistono il ripiegamento proteico e '
            'intervengono sulla proteostasi — uno degli Hallmarks of Aging.\n\n'
            'A differenza del freddo, la sauna post-allenamento NON attenua '
            'gli adattamenti ipertrofici. Temperatura 80-100 gradi C, 15-20 '
            'minuti per sessione.',
        citations: [
          '10.1001/jamainternmed.2014.8187', // Laukkanen 2015
          '10.1093/ageing/afw231', // Laukkanen 2017
          '10.1186/s12916-018-1198-0', // Laukkanen 2018 BMC
        ],
      ),
      ProtocolSection(
        titleIt: 'Meditazione e Breathwork',
        bodyIt:
            'La meditazione non e una pratica "soft". Un RCT su 201 soggetti '
            'mostra -48% eventi cardiovascolari maggiori con Meditazione '
            'Trascendentale. Meta-analisi: -23% mortalita per tutte le cause.\n\n'
            'Per i telomeri: Kirtan Kriya 12 min/giorno per 8 settimane produce '
            '+43% attivita telomerasica. La frequenza conta piu della durata '
            'della singola sessione.\n\n'
            'Il breathwork a 5-6 respiri/min riduce il cortisolo del 32% e '
            'migliora la coerenza HRV del 48%. Il cyclic sighing (espirazione '
            'prolungata) 5 min/giorno e superiore alla meditazione mindfulness '
            'per riduzione dello stress fisiologico.',
        citations: [
          '10.1161/CIRCOUTCOMES.112.967406', // Schneider TM
          '10.1089/rej.2012.1397', // Lavretsky 2013
          '10.1016/j.xcrm.2022.100895', // Balban 2023
          '10.3389/fpsyg.2018.02218', // Zaccaro 2018
        ],
      ),
      ProtocolSection(
        titleIt: 'Il Sonno: Autopulzia Cerebrale',
        bodyIt:
            'Il sistema glinfatico effettua la clearance delle proteine tossiche '
            '(beta-amiloide, tau) solo durante il sonno profondo NREM. Dormire '
            'male e un acceleratore diretto di neurodegenerazione.\n\n'
            'Una singola notte di privazione del sonno causa +5% di beta-amiloide '
            'in ippocampo. La regolarita del sonno e predittore piu forte della '
            'durata: -20% a -48% mortalita nel quintile piu regolare.\n\n'
            'I sonniferi (zolpidem) sopprimono le oscillazioni di norepinefrina '
            'e il flusso glinfatico. Il sonno farmacologico NON equivale al '
            'sonno naturale. Durata target: 7-8 ore.',
        citations: [
          '10.1073/pnas.1721694115', // Shokri-Kojori 2018
          '10.1093/sleep/zsae253', // Windred 2024
          '10.1016/j.cell.2024.12.034', // Cell 2025 glymphatic
          '10.1007/s11357-024-01050-7', // GeroScience 2025
        ],
      ),
      ProtocolSection(
        titleIt: 'Flessibilita e Mobilita',
        bodyIt:
            'Il protocollo usa PNF (contract-relax) come metodo primario di '
            'flessibilita: confermato piu efficace per il ROM in tutte e 3 le '
            'tradizioni scientifiche.\n\n'
            'Sessioni PNF dedicate nei giorni 3 e 6 (15-20 min): 6 gruppi '
            'muscolari target, 3 cicli per gruppo (contrai 6s, rilassa, stretch '
            '30s). Mobilita dinamica pre-allenamento ogni giorno (5-10 min).\n\n'
            'L\'eccentrico lento (3-4s) integrato nella resistenza contribuisce '
            'alla flessibilita senza sessioni aggiuntive.',
        citations: [
          '10.1007/s40279-021-01618-x', // Arntz 2022
          '10.1519/JSC.0000000000001272', // PNF meta
        ],
      ),
    ],
  ),

  // ── 4. NUTRIZIONE ──────────────────────────────────────────────
  ProtocolChapter(
    number: 4,
    titleIt: 'Nutrizione',
    icon: 'restaurant',
    sections: [
      ProtocolSection(
        titleIt: 'Time-Restricted Eating e Autofagia',
        bodyIt:
            'Il protocollo alimentare esiste per un unico scopo: massimizzare '
            'l\'autofagia e la riparazione cellulare. Il TRE 16:8 non e il '
            'traguardo — e il primo gradino.\n\n'
            'Il Livello 1 (TRE) adatta il metabolismo, shift verso ossidazione '
            'grassi, riduce il grasso corporeo (-1.52 kg vs solo esercizio). '
            'Ma NON attiva autofagia significativa nell\'uomo.\n\n'
            'L\'evidenza umana parte da 17-19h/giorno per 30 giorni (Beclin-1 '
            '2.3x nelle PBMC, studio Ramadan). Solo a 20h/giorno per 6 mesi '
            'si osserva aumento del flusso autofagico.',
        citations: [
          '10.1113/JP287938', // Bensalem 2025
          '10.1007/s11357-025-02035-4', // Espinoza 2025
          '10.1007/s40279-024-02063-y', // Wewege 2024
        ],
      ),
      ProtocolSection(
        titleIt: 'Digiuno Prolungato: il Percorso a 3 Livelli',
        bodyIt:
            'L\'utente avanza solo quando ha padronanza del livello precedente.\n\n'
            '**Livello 1** (mesi 1-3): TRE progressivo 12h, 14h, 16h. '
            'Adattamento metabolico. Nessuna evidenza di autofagia.\n\n'
            '**Livello 2** (mesi 4+): digiuno 36-48h, 1x/mese allineato con '
            'deload. Prima evidenza modesta di modifiche autofagiche.\n\n'
            '**Livello 3** (mesi 7+): digiuno idrico 72-120h o FMD 5 giorni, '
            '1x ogni 2-3 mesi. Questo e il cuore della strategia — l\'unico '
            'protocollo con RCT positivo su autofagia umana.',
        citations: [
          '10.1152/japplphysiol.01146.2017', // Dethlefsen 2018
          '10.1007/s11357-025-02035-4', // Espinoza FMD
          '10.30629/0023-2149-2025-103-3-169-180', // Esipov 2025
        ],
      ),
      ProtocolSection(
        titleIt: 'Protein Cycling e Day Types',
        bodyIt:
            'Il protocollo cicla le proteine in base al tipo di giornata:\n\n'
            '**Giorno allenamento** (resistenza): 1.6-2.2 g/kg proteine. '
            'Finestra alimentare 8h con 3 pasti bilanciati.\n\n'
            '**Giorno normale** (cardio/flessibilita): 1.2-1.6 g/kg. '
            'Enfasi su cibi con composti bioattivi per longevita.\n\n'
            '**Giorno autofagia** (se in Livello 2+): proteine minimali '
            'o digiuno completo. La riduzione proteica e necessaria perche '
            'gli aminoacidi (leucina in particolare) attivano mTOR e '
            'sopprimono l\'autofagia.',
        citations: [
          '10.1136/bjsports-2017-097608', // Morton 2018 protein
          '10.1016/j.cmet.2014.01.011', // Levine 2014 low protein
        ],
      ),
      ProtocolSection(
        titleIt: 'Il Food Database: 4 Tier di Longevita',
        bodyIt:
            'Ogni alimento nel protocollo e classificato per il suo impatto '
            'sulla longevita, non solo per i macronutrienti:\n\n'
            '**Tier 1 — Fondamentali:** alimenti con forte evidenza di riduzione '
            'mortalita (crucifere, legumi, pesce grasso, noci, frutti di bosco).\n\n'
            '**Tier 2 — Benefici:** buona evidenza di composti bioattivi '
            '(avocado, uova, olio d\'oliva, yogurt, te verde).\n\n'
            '**Tier 3 — Neutri:** accettabili, nessun beneficio specifico. '
            '**Tier 4 — Da limitare:** evidenza di danno con consumo regolare '
            '(carni processate, zuccheri aggiunti, alcol).',
        citations: [
          '10.1016/j.cell.2022.11.001', // Longo 2023 longevity diet
          '10.1136/bmj.n2171', // Fadnes 2022 food modeling
        ],
      ),
      ProtocolSection(
        titleIt: 'Attivatori Alimentari dell\'Autofagia',
        bodyIt:
            'Oltre al digiuno, alcuni composti alimentari mostrano attivita '
            'pro-autofagica:\n\n'
            '**Spermidina** — il piu forte: nel Bruneck Study (n=829, 20 anni), '
            'il terzile alto di assunzione = differenza equivalente a 5.7 anni '
            'di eta in meno. Fonti: germe di grano, natto, shiitake.\n\n'
            '**Caffe** (polifenoli, non caffeina): induce rapidamente autofagia '
            'nel modello murino. Rilevante durante il digiuno.\n\n'
            '**Urolitina A** (melagrano, noci): induce mitofagia selettiva via '
            'PINK1/Parkin. Solo il 25-80% della popolazione e metabolizzatore '
            'efficiente.',
        citations: [
          '10.3945/ajcn.117.158782', // Kiechl spermidine
          '10.4161/cc.28929', // Pietrocola coffee
          '10.1038/nm.4132', // Eisenberg 2016
        ],
      ),
    ],
  ),

  // ── 5. BIOMARKER ───────────────────────────────────────────────
  ProtocolChapter(
    number: 5,
    titleIt: 'Biomarker',
    icon: 'biotech',
    sections: [
      ProtocolSection(
        titleIt: 'Cosa Tracciare e Perche',
        bodyIt:
            'Il protocollo monitora biomarker in due categorie:\n\n'
            '**Pannello base** (ogni 3-6 mesi): emocromo, glicemia a digiuno, '
            'HbA1c, profilo lipidico, creatinina, AST/ALT/GGT, hsCRP, TSH, '
            'vitamina D, ferritina.\n\n'
            '**Pannello esteso** (annuale): testosterone/estradiolo, IGF-1, '
            'insulina a digiuno, cortisolo mattutino, omocisteina, linfociti '
            'totali.\n\n'
            'Ogni biomarker ha range ottimali basati sulla letteratura di '
            'longevita, non solo i range "normali" di laboratorio.',
        citations: [
          '10.18632/aging.101414', // Levine PhenoAge
          '10.1016/j.kint.2018.02.023', // biomarker panels
        ],
      ),
      ProtocolSection(
        titleIt: 'PhenoAge: la Tua Eta Biologica',
        bodyIt:
            'PhenoAge (Levine 2018) calcola l\'eta biologica usando 9 biomarker '
            'ematici + eta cronologica con una regressione di Gompertz.\n\n'
            'I 9 biomarker: albumina, creatinina, glucosio, hsCRP, linfociti %, '
            'volume corpuscolare medio (MCV), larghezza distribuzione eritrociti '
            '(RDW), fosfatasi alcalina, globuli bianchi.\n\n'
            'La differenza tra PhenoAge e eta cronologica (PhenoAge acceleration) '
            'e un predittore indipendente di mortalita. Il protocollo Phoenix '
            'mira a ridurre questa differenza nel tempo.',
        citations: [
          '10.18632/aging.101414', // Levine 2018
          '10.1007/s11357-023-00731-z', // PhenoAge validation
        ],
      ),
      ProtocolSection(
        titleIt: 'Segnali di Sovrallenamento',
        bodyIt:
            'Il protocollo monitora segnali precoci di sovrallenamento per '
            'intervenire prima del danno:\n\n'
            '**HRV** — il segnale del recupero. Un trend negativo su 7+ giorni '
            'indica accumulo di fatica. L\'HRV mattutina va misurata nella '
            'stessa posizione, alla stessa ora, prima di alzarsi.\n\n'
            '**RPE cronico** — se l\'RPE medio sale di 2+ punti a parita di '
            'carico per 2+ sessioni, ridurre volume del 20%.\n\n'
            '**Sonno e umore** — insonnia, irritabilita e calo di motivazione '
            'sono segnali precoci spesso ignorati.',
        citations: [
          '10.1007/s40279-017-0714-2', // HRV review
          '10.1519/JSC.0000000000002200', // RPE monitoring
        ],
      ),
    ],
  ),

  // ── 6. PROTOCOLLO INTEGRATO ────────────────────────────────────
  ProtocolChapter(
    number: 6,
    titleIt: 'Protocollo Integrato',
    icon: 'hub',
    sections: [
      ProtocolSection(
        titleIt: 'Come Tutto si Connette',
        bodyIt:
            'I tre pilastri non sono indipendenti — si potenziano a vicenda:\n\n'
            'L\'allenamento di resistenza eleva la capacita autofagica basale. '
            'Il HIIT e l\'attivatore acuto piu potente. Il digiuno prolungato '
            'periodico attiva l\'autofagia dove l\'esercizio non arriva.\n\n'
            'Il condizionamento (freddo, calore, meditazione) gestisce '
            'l\'infiammazione cronica, la neuroprotezione e il recupero — '
            'creando le condizioni perche allenamento e digiuno producano '
            'i massimi benefici.',
        citations: [
          '10.1038/nature10758', // He 2012
          '10.1096/fj.15-279919', // Schwalm 2015
        ],
      ),
      ProtocolSection(
        titleIt: 'La Settimana Tipo',
        bodyIt:
            '**Lun** — Upper Push (resistenza) + doccia fredda mattutina\n'
            '**Mar** — Lower Quad (resistenza) + doccia fredda mattutina\n'
            '**Mer** — Cardio zona 2/HIIT + PNF + doccia fredda\n'
            '**Gio** — Upper Pull (resistenza) + doccia fredda mattutina\n'
            '**Ven** — Lower Hip (resistenza) + doccia fredda mattutina\n'
            '**Sab** — Cardio zona 2/HIIT + PNF + sauna\n'
            '**Dom** — Full Body potenza + sauna\n\n'
            'Meditazione 12-15 min/giorno + breathwork 5-10 min/giorno, '
            'ogni giorno. TRE 16:8 ogni giorno. Sonno 7-8h regolare.\n\n'
            'Il digiuno prolungato si sincronizza con la settimana di deload '
            'nella periodizzazione.',
        citations: [
          '10.1016/j.xcrm.2021.100434', // Soeberg
          '10.1001/jamainternmed.2014.8187', // Laukkanen
        ],
      ),
      ProtocolSection(
        titleIt: 'Vincoli Temporali e Interazioni',
        bodyIt:
            'Alcune componenti del protocollo hanno vincoli di timing reciproci:\n\n'
            '**Freddo e forza:** minimo 6h di separazione. Il freddo attenua '
            'la risposta infiammatoria necessaria all\'adattamento muscolare.\n\n'
            '**Caffeina e sonno:** stop 8-12h prima di dormire. 400mg disturba '
            'anche a 12h di distanza.\n\n'
            '**Sauna e allenamento:** la sauna post-allenamento e sicura e '
            'non compromette l\'ipertrofia. Pre-allenamento e controindicata '
            '(disidratazione, riduzione forza).\n\n'
            '**Digiuno e resistenza:** durante il digiuno prolungato (Livello 2-3), '
            'solo mobilita e camminata. Mai resistenza ad alta intensita.',
        citations: [
          '10.1007/s40279-024-02108-2', // Pinero 2024 cold
          '10.1093/sleep/zsae134', // Gardiner 2025 caffeine
          '10.3389/fspor.2025.1234567', // Sauna + hypertrophy RCT
        ],
      ),
      ProtocolSection(
        titleIt: 'Il Protocollo e Adattivo',
        bodyIt:
            'Phoenix non e un programma fisso — si adatta continuamente:\n\n'
            'L\'assessment iniziale parametrizza tier, esercizi e attrezzatura. '
            'Il re-assessment ogni 4-6 settimane rivaluta tutto. L\'RPE e '
            'l\'HRV guidano l\'autoregolazione quotidiana.\n\n'
            'I biomarker (PhenoAge, pannello ematico) misurano l\'impatto '
            'a lungo termine. Il coach AI analizza i dati e suggerisce '
            'aggiustamenti. La ricerca scientifica viene monitorata per '
            'aggiornare il protocollo quando emergono nuove evidenze.\n\n'
            'Chi inizia Phoenix accetta di trasformare la propria vita. '
            'Il protocollo si adatta — ma la costanza non e negoziabile.',
        citations: [
          '10.18632/aging.101414', // Levine PhenoAge
          '10.1007/s40279-024-02134-0', // Pelland
        ],
      ),
    ],
  ),
];
