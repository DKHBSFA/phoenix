import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

/// Seed data for the exercises table.
/// Based on Phoenix Protocol section 2 (Training).
/// 5 categories × ~10 exercises each × 3 equipment variants = ~80 records.
/// Instructions enriched from phoenix-protocol.md §2.7, esecuzione-esercizi.md,
/// and verified biomechanics sources (NSCA, Schoenfeld 2010, Hartmann 2013).
List<ExercisesCompanion> get exerciseSeedData => [
  // ============================================================
  // PUSH (Upper Push - Day 1)
  // ============================================================
  // -- Compound exercises --
  // Gym
  _push('Chest Press Machine', 1, 'gym', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Regola il sedile. Spingi avanti senza bloccare i gomiti. 3s eccentrica.',
      'Esercizio guidato che isola la spinta orizzontale in sicurezza. Ideale per principianti o come pre-affaticamento.\n\n'
      'PERCHÉ: Costruisce forza di base nella spinta senza la complessità della stabilizzazione del bilanciere.\n\n'
      'ERRORI COMUNI:\n'
      '• Sedile troppo alto o basso — le impugnature devono essere all\'altezza del petto medio\n'
      '• Bloccare i gomiti in estensione — mantieni una leggera flessione\n'
      '• Staccare la schiena dallo schienale — mantieni contatto lombare\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.\n\n'
      'VARIANTE FACILITATA: Riduci il carico e concentrati sulla fase eccentrica lenta (3-4s).',
      3, 10, 15),
  _push('Bench Press', 2, 'gym', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Scapole addotte e depresse. Bilanciere al petto. Piedi a terra.',
      'Il fondamentale della spinta orizzontale. Sviluppa forza e massa del petto, deltoidi anteriori e tricipiti.\n\n'
      'PERCHÉ: Massimo carico possibile sul pattern di spinta orizzontale. La posizione supina elimina la compensazione del core.\n\n'
      'ERRORI COMUNI:\n'
      '• Scapole non retratte — addurre e deprimere le scapole PRIMA di sdraiarsi\n'
      '• Rimbalzare il bilanciere sul petto — toccare leggero, poi spingere\n'
      '• Gomiti aperti a 90° — mantenere ~45° per proteggere la spalla\n\n'
      'RESPIRAZIONE: Inspira profondo prima della discesa (Valsalva), espira durante la spinta.\n\n'
      'VARIANTE FACILITATA: DB Bench Press per maggiore ROM e meno stress articolare.',
      3, 8, 12),
  _push('Incline Bench Press', 3, 'gym', 'Pettorali alti, Deltoidi anteriori', 'Tricipiti',
      'Panca 30-45°. Bilanciere alla clavicola. Gomiti 45°.',
      'Variante inclinata che enfatizza la porzione clavicolare del pettorale e i deltoidi anteriori.\n\n'
      'PERCHÉ: 30-45° è l\'angolo ottimale per i pettorali alti senza trasformare il movimento in un overhead press.\n\n'
      'ERRORI COMUNI:\n'
      '• Panca troppo inclinata (>45°) — diventa un overhead press mascherato\n'
      '• Traiettoria dritta — il bilanciere deve andare leggermente verso la clavicola\n'
      '• Perdere l\'arco toracico — mantieni le scapole retratte come nella panca piana\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.\n\n'
      'VARIANTE FACILITATA: Incline DB Press con manubri leggeri.',
      4, 6, 10),
  _push('DB Shoulder Press', 4, 'gym', 'Deltoidi, Pettorali alti', 'Tricipiti',
      'Seduto, schiena dritta. Manubri alle orecchie. Spingi sopra la testa.',
      'Press verticale con manubri. Costruisce deltoidi forti e stabilità di spalla.\n\n'
      'PERCHÉ: I manubri consentono una traiettoria naturale e maggiore ROM rispetto al bilanciere.\n\n'
      'ERRORI COMUNI:\n'
      '• Inarcare la schiena — mantieni il core contratto e la schiena aderente allo schienale\n'
      '• Portare i manubri troppo in basso — fermarsi all\'altezza delle orecchie\n'
      '• Estensione incompleta — spingi fino a braccia quasi distese sopra la testa\n\n'
      'RESPIRAZIONE: Inspira in basso, espira durante la spinta verso l\'alto.\n\n'
      'VARIANTE FACILITATA: Seduto con schienale alto per maggiore supporto.',
      4, 6, 10),
  _push('Weighted Dip', 5, 'gym', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Busto leggermente inclinato avanti. Gomiti a 90°. Peso alla cintura.',
      'Dip zavorrato — esercizio avanzato per forza e massa della parte superiore del corpo.\n\n'
      'PERCHÉ: Carica il pattern di spinta verticale con tutto il peso corporeo più zavorra. L\'inclinazione del busto sposta il focus sui pettorali.\n\n'
      'ERRORI COMUNI:\n'
      '• Scendere troppo — fermarsi quando l\'omero è parallelo al suolo per proteggere la spalla\n'
      '• Busto verticale — inclinarsi leggermente avanti per attivare più pettorali\n'
      '• Aggiungere troppo peso troppo presto — padroneggiare prima 15+ dip a corpo libero\n\n'
      'RESPIRAZIONE: Inspira nella discesa controllata, espira nella risalita.\n\n'
      'VARIANTE FACILITATA: Dip a corpo libero o dip assistiti alla macchina.',
      4, 5, 8),
  _push('Barbell OHP', 6, 'gym', 'Deltoidi, Trapezio', 'Tricipiti, Core',
      'In piedi, bilanciere dalla clavicola sopra la testa. Core attivo.',
      'Overhead press con bilanciere in piedi — il re degli esercizi di spinta verticale.\n\n'
      'PERCHÉ: Massimo carico sul pattern overhead. Richiede stabilità del core e coordinazione di tutto il corpo.\n\n'
      'ERRORI COMUNI:\n'
      '• Inarcare la lombare — stringere glutei e addominali come in un plank in piedi\n'
      '• Traiettoria curva — il bilanciere deve salire dritto, la testa si sposta indietro per farlo passare\n'
      '• Non bloccare sopra — completare il lockout con le spalle "attive" verso l\'alto\n\n'
      'RESPIRAZIONE: Inspira prima della spinta, espira con forza durante il push.\n\n'
      'VARIANTE FACILITATA: Seated DB Shoulder Press.',
      4, 4, 6),

  // Home
  _push('Floor Press Manubri', 1, 'home', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Sdraiato a terra. Gomiti toccano il pavimento. Spingi su.',
      'Press dal pavimento — alternativa casalinga alla panca piana. Il pavimento limita la ROM e protegge le spalle.\n\n'
      'PERCHÉ: Elimina la fase più rischiosa della panca (sotto il parallelo) mantenendo lo stimolo su pettorali e tricipiti.\n\n'
      'ERRORI COMUNI:\n'
      '• Rimbalzare i gomiti a terra — appoggiare con controllo, pausa 1s, poi spingere\n'
      '• Piedi sollevati — piedi a terra, ginocchia piegate per stabilità\n'
      '• Gomiti aperti — mantieni ~45° rispetto al torso\n\n'
      'RESPIRAZIONE: Inspira quando i gomiti toccano, espira nella spinta.',
      3, 10, 15),
  _push('DB Bench Press', 2, 'home', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Su panca o step. Manubri al petto. Spingi su convergendo.',
      'Press su panca con manubri. Maggiore ROM e attivazione degli stabilizzatori rispetto al bilanciere.\n\n'
      'PERCHÉ: Ogni braccio lavora indipendentemente, correggendo asimmetrie di forza.\n\n'
      'ERRORI COMUNI:\n'
      '• Manubri troppo larghi in basso — tenerli in linea con il petto\n'
      '• Non convergere in alto — i manubri si avvicinano sopra il petto\n'
      '• Scapole non retratte — set-up identico alla panca con bilanciere\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.',
      3, 8, 12),
  _push('DB Incline Press', 3, 'home', 'Pettorali alti, Deltoidi anteriori', 'Tricipiti',
      'Panca inclinata. Manubri convergenti sopra il petto.',
      'Versione inclinata del DB press per enfatizzare i pettorali alti.\n\n'
      'PERCHÉ: Combinazione ideale tra ROM dei manubri e angolo per pettorali alti.\n\n'
      'ERRORI COMUNI:\n'
      '• Panca troppo inclinata — 30° è sufficiente\n'
      '• Perdere il contatto scapolare — mantieni le scapole retratte sulla panca\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira spingendo.',
      4, 6, 10),
  _push('KB Press', 4, 'home', 'Deltoidi, Pettorali alti', 'Tricipiti',
      'In piedi, kettlebell alla spalla. Spingi sopra la testa. Core attivo.',
      'Press overhead unilaterale con kettlebell. La distribuzione del peso sfida la stabilità.\n\n'
      'PERCHÉ: Il KB forza una traiettoria naturale e attiva gli stabilizzatori della spalla più dei manubri.\n\n'
      'ERRORI COMUNI:\n'
      '• Polso piegato — il KB deve appoggiare sull\'avambraccio con polso neutro\n'
      '• Compensazione laterale — non piegarti dal lato opposto\n'
      '• Core rilassato — stringi addominali e glutei per tutta la durata\n\n'
      'RESPIRAZIONE: Inspira nel rack, espira durante la spinta.',
      4, 6, 10),
  _push('Ring Dip', 5, 'home', 'Pettorali, Deltoidi anteriori', 'Tricipiti, Core',
      'Anelli stabili. Scendi lento. Gomiti vicini al corpo.',
      'Dip sugli anelli — versione avanzata che richiede stabilizzazione estrema.\n\n'
      'PERCHÉ: L\'instabilità degli anelli recluta gli stabilizzatori di spalla e core molto più delle parallele fisse.\n\n'
      'ERRORI COMUNI:\n'
      '• Anelli che ruotano — mantieni gli anelli vicini al corpo, ruota i polsi in fuori (turn-out) in alto\n'
      '• Scendere troppo — fermarsi all\'omero parallelo\n'
      '• Perdere il corpo dritto — stringi glutei e core\n\n'
      'RESPIRAZIONE: Inspira controllato nella discesa, espira nella risalita.\n\n'
      'VARIANTE FACILITATA: Dip su parallele fisse o dip assistiti con elastico.',
      4, 5, 8),

  // Bodyweight
  _push('Wall Push-up', 1, 'bodyweight', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Mani al muro, larghezza spalle. Corpo dritto. 3s eccentrica.',
      'Primo step nella progressione push-up. Perfetto per costruire il pattern motorio corretto.\n\n'
      'PERCHÉ: Carico ridotto (~30% peso corporeo) per apprendere la forma corretta senza rischio.\n\n'
      'ERRORI COMUNI:\n'
      '• Anche che cedono avanti — stringere glutei, corpo dritto come una tavola\n'
      '• Mani troppo avanti — devono essere all\'altezza del petto\n'
      '• Gomiti aperti a 90° — mantieni ~45° dal torso\n\n'
      'RESPIRAZIONE: Inspira avvicinandoti al muro, espira spingendo via.\n\n'
      'VARIANTE FACILITATA: Avvicinarsi al muro per ridurre la leva.',
      3, 12, 20),
  _push('Incline Push-up', 2, 'bodyweight', 'Pettorali, Deltoidi anteriori', 'Tricipiti',
      'Mani su rialzo (sedia/step). Corpo dritto. 3s giù.',
      'Push-up inclinato — step intermedio tra muro e pavimento.\n\n'
      'PERCHÉ: Carico progressivamente maggiore (~50-60% peso corporeo) mantenendo il pattern corretto.\n\n'
      'ERRORI COMUNI:\n'
      '• Superficie instabile — usare un rialzo solido e fisso\n'
      '• Perdere la linea del corpo — glutei e core attivi\n'
      '• Scendere troppo veloce — eccentrica lenta 3s\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.',
      3, 10, 15),
  _push('Push-up', 3, 'bodyweight', 'Pettorali, Deltoidi anteriori', 'Tricipiti, Core',
      'Corpo dritto testa-talloni. Gomiti 45°. Petto a terra.',
      'Il fondamentale corpo libero per la spinta. Mani a livello del petto, leggermente più larghe delle spalle.\n\n'
      'PERCHÉ: Allena pettorali, deltoidi e tricipiti con il proprio peso corporeo. Richiede stabilizzazione del core.\n\n'
      'ERRORI COMUNI:\n'
      '• Anche che cedono o si alzano — "l\'unico errore che rende l\'esercizio inutile" (fonti RU)\n'
      '• Gomiti aperti a 90° — rischio impingement spalla. Mantieni ~45°\n'
      '• Range incompleto — il petto deve sfiorare il pavimento\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira spingendo.\n\n'
      'VARIANTE FACILITATA: Push-up sulle ginocchia (stesso pattern, meno carico).',
      3, 8, 12),
  _push('Diamond Push-up', 4, 'bodyweight', 'Tricipiti, Pettorali interni', 'Deltoidi',
      'Mani unite a diamante sotto il petto. Gomiti vicini.',
      'Push-up a presa stretta per enfatizzare i tricipiti e la porzione sternale del pettorale.\n\n'
      'PERCHÉ: La presa stretta sposta il carico sui tricipiti (~30% in più rispetto al push-up standard).\n\n'
      'ERRORI COMUNI:\n'
      '• Mani troppo avanti — devono essere sotto il petto, non sotto il viso\n'
      '• Gomiti che si aprono — tenerli vicini al corpo\n'
      '• Cedere col bacino — stessa postura rigida del push-up standard\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.\n\n'
      'VARIANTE FACILITATA: Diamond push-up inclinato su un rialzo.',
      4, 6, 10),
  _push('Archer Push-up', 5, 'bodyweight', 'Pettorali, Deltoidi', 'Tricipiti, Core',
      'Mani larghe. Scendi su un braccio, l\'altro si estende. Alterna.',
      'Push-up asimmetrico che prepara al push-up su un braccio. Un braccio lavora, l\'altro assiste.\n\n'
      'PERCHÉ: Carica asimmetricamente (~70-80% su un braccio) costruendo forza unilaterale progressiva.\n\n'
      'ERRORI COMUNI:\n'
      '• Ruotare il torso — mantenere fianchi e spalle paralleli al suolo\n'
      '• Braccio esteso piegato — deve essere dritto come supporto\n'
      '• Saltare il push-up standard — padroneggiare 20+ push-up prima\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira spingendo.\n\n'
      'VARIANTE FACILITATA: Push-up standard o diamond push-up.',
      4, 4, 8),
  _push('Planche Progression', 6, 'bodyweight', 'Deltoidi anteriori, Pettorali', 'Core, Bicipiti',
      'Lean planche: mani a terra, corpo inclinato avanti. Tenere la posizione.',
      'Propedeutica alla planche completa. Skill avanzata di spinta isometrica.\n\n'
      'PERCHÉ: Massima attivazione dei deltoidi anteriori e del core in isometria. Richiede anni di progressione.\n\n'
      'ERRORI COMUNI:\n'
      '• Braccia piegate — devono restare distese\n'
      '• Schiena inarcata — posterior pelvic tilt, stringi glutei\n'
      '• Polsi non preparati — riscaldare sempre i polsi prima\n\n'
      'RESPIRAZIONE: Respira normalmente mantenendo la posizione. Non trattenere il fiato.\n\n'
      'VARIANTE FACILITATA: Planche lean (inclinazione leggera) o tuck planche (ginocchia al petto).',
      4, 3, 6),

  // -- Accessory push --
  _pushAccessory('Tricep Extension', 'gym', 'Tricipiti', '',
      'Cavo o manubrio sopra la testa. Estendi completamente.',
      'Isolamento tricipiti con cavo o manubrio overhead.\n\n'
      'ERRORI COMUNI:\n'
      '• Gomiti che si aprono — tienili fermi puntati avanti\n'
      '• Usare il corpo per spingere — solo l\'avambraccio si muove\n\n'
      'RESPIRAZIONE: Inspira nella flessione, espira nell\'estensione.',
      3, 10, 15),
  _pushAccessory('Lateral Raise', 'gym', 'Deltoidi laterali', '',
      'Manubri ai fianchi. Alza a 90° con controllo.',
      'Isolamento del deltoide laterale per ampiezza delle spalle.\n\n'
      'ERRORI COMUNI:\n'
      '• Usare lo slancio — alzare con controllo, peso leggero\n'
      '• Alzare oltre 90° — il trapezio prende il sopravvento\n'
      '• Pollici verso l\'alto — leggera rotazione interna (mignolo leggermente più alto)\n\n'
      'RESPIRAZIONE: Inspira in basso, espira alzando.',
      3, 12, 15),
  _pushAccessory('Face Pull', 'gym', 'Deltoidi posteriori, Trapezio', 'Romboidi',
      'Cavo alto, tira verso il viso. Gomiti alti. Stringi scapole.',
      'Esercizio fondamentale per la salute della spalla e la postura. Bilancia il volume di spinta.\n\n'
      'ERRORI COMUNI:\n'
      '• Tirare troppo in basso — il cavo va al viso, gomiti alla stessa altezza delle spalle\n'
      '• Non ruotare esternamente — alla fine del movimento, ruota le mani verso fuori\n'
      '• Troppo peso — usare carichi leggeri con controllo\n\n'
      'RESPIRAZIONE: Inspira in estensione, espira tirando e stringendo le scapole.',
      3, 12, 15),

  // ============================================================
  // PULL (Upper Pull - Day 4)
  // ============================================================
  // Gym
  _pull('Lat Pulldown', 1, 'gym', 'Gran dorsale, Bicipiti', 'Trapezio, Romboidi',
      'Presa larga. Tira alla clavicola. Scapole depresse.',
      'Tirata verticale guidata — fondamentale per sviluppare il gran dorsale e preparare ai pull-up.\n\n'
      'PERCHÉ: Permette di modulare il carico esatto, impossibile con i pull-up dove si usa tutto il peso corporeo.\n\n'
      'ERRORI COMUNI:\n'
      '• Tirare dietro la nuca — SEMPRE davanti, alla clavicola. Dietro la nuca carica le cervicali\n'
      '• Inclinarsi troppo indietro — leggera inclinazione (10-15°), non usare lo slancio\n'
      '• Iniziare con le braccia — "porta le scapole in tasca" prima di tirare con i bicipiti\n\n'
      'RESPIRAZIONE: Inspira in alto, espira tirando giù.',
      3, 10, 15),
  _pull('Seated Row', 2, 'gym', 'Romboidi, Trapezio', 'Bicipiti, Gran dorsale',
      'Petto al cuscino. Tira ai fianchi. Stringi scapole.',
      'Tirata orizzontale alla macchina. Enfatizza romboidi e trapezio medio per una schiena forte.\n\n'
      'PERCHÉ: Bilancia la spinta orizzontale (bench press). Fondamentale per la postura.\n\n'
      'ERRORI COMUNI:\n'
      '• Tirare con i bicipiti — inizia il movimento stringendo le scapole\n'
      '• Oscillare col busto — petto al cuscino, solo le braccia si muovono\n'
      '• Non completare la contrazione — stringi le scapole 1s alla fine\n\n'
      'RESPIRAZIONE: Inspira in estensione, espira tirando.',
      3, 8, 12),
  _pull('Barbell Row', 3, 'gym', 'Gran dorsale, Romboidi', 'Bicipiti, Trapezio',
      'Busto a 45°. Bilanciere all\'ombelico. Gomiti vicini.',
      'Remata con bilanciere — il re delle tirate orizzontali per forza e massa dorsale.\n\n'
      'PERCHÉ: Massimo carico sul pattern di tirata orizzontale. Allena anche la catena posteriore isometricamente.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena arrotondata — SCHIENA NEUTRA, stringi gli erettori\n'
      '• Usare lo slancio del corpo — il busto resta fermo a 45°, solo le braccia tirano\n'
      '• Tirare al petto — il bilanciere va all\'ombelico per massima attivazione dorsale\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando.\n\n'
      'VARIANTE FACILITATA: Seated Row alla macchina.',
      4, 6, 10),
  _pull('Pull-up', 4, 'gym', 'Gran dorsale, Bicipiti', 'Trapezio, Core',
      'Presa prona, larghezza spalle. Mento sopra la sbarra.',
      'Il fondamentale della tirata verticale a corpo libero. Sviluppa dorsali e bicipiti con il proprio peso.\n\n'
      'PERCHÉ: Forza funzionale completa della parte superiore. Indicatore di fitness generale.\n\n'
      'ERRORI COMUNI:\n'
      '• Kipping (slancio) — pull-up stretti, zero slancio per la versione di forza\n'
      '• Mento che "spunta" — il mento deve superare la sbarra chiaramente\n'
      '• Scendere di scatto — eccentrica controllata (2-3s)\n\n'
      'RESPIRAZIONE: Inspira appeso, espira tirando su.\n\n'
      'VARIANTE FACILITATA: Pull-up negatives o pull-up con elastico assistivo.',
      4, 5, 8),
  _pull('Weighted Pull-up', 5, 'gym', 'Gran dorsale, Bicipiti', 'Trapezio, Core',
      'Peso alla cintura. Presa prona. Mento sopra la sbarra.',
      'Pull-up zavorrato — progressione per chi padroneggia 10+ pull-up a corpo libero.\n\n'
      'PERCHÉ: Permette il sovraccarico progressivo quando il peso corporeo non è più sufficiente.\n\n'
      'ERRORI COMUNI:\n'
      '• Aggiungere troppo peso — iniziare con 2.5-5kg e aumentare gradualmente\n'
      '• Perdere la forma — stessi standard del pull-up a corpo libero\n'
      '• Oscillare col peso — corpo fermo, core contratto\n\n'
      'RESPIRAZIONE: Inspira appeso, espira tirando su.',
      4, 4, 6),
  _pull('Muscle-up Progression', 6, 'gym', 'Gran dorsale, Pettorali, Tricipiti', 'Core',
      'Pull-up esplosiva + transizione sopra la sbarra.',
      'Skill avanzata che combina pull-up e dip in un unico movimento esplosivo.\n\n'
      'PERCHÉ: Massima espressione di forza e coordinazione della parte superiore del corpo.\n\n'
      'ERRORI COMUNI:\n'
      '• Provare senza basi — servono 10+ pull-up puliti e 15+ dip\n'
      '• Transizione lenta — il passaggio deve essere esplosivo e rapido\n'
      '• Presa troppo larga — presa a larghezza spalle, false grip facilita la transizione\n\n'
      'RESPIRAZIONE: Espira con forza durante la trazione esplosiva.\n\n'
      'VARIANTE FACILITATA: Pull-up esplosive (tirare il petto alla sbarra).',
      4, 3, 5),

  // Home
  _pull('Band Pull-apart', 1, 'home', 'Deltoidi posteriori, Romboidi', 'Trapezio',
      'Banda elastica tesa. Braccia dritte, apri allargando.',
      'Esercizio posturale con elastico per deltoidi posteriori e scapole.\n\n'
      'PERCHÉ: Corregge lo squilibrio anteriore/posteriore causato dalla vita sedentaria.\n\n'
      'ERRORI COMUNI:\n'
      '• Braccia piegate — mantieni gomiti distesi\n'
      '• Alzare le spalle — scapole depresse\n'
      '• Elastico troppo forte — controllo > resistenza\n\n'
      'RESPIRAZIONE: Inspira a braccia avanti, espira aprendo.',
      3, 12, 20),
  _pull('DB Row', 2, 'home', 'Gran dorsale, Romboidi', 'Bicipiti',
      'Un ginocchio su panca. Manubrio al fianco. Scapola verso la colonna.',
      'Remata unilaterale con manubrio. Isola un lato alla volta per correggere asimmetrie.\n\n'
      'PERCHÉ: Lavoro unilaterale + range completo. La posizione su panca protegge la lombare.\n\n'
      'ERRORI COMUNI:\n'
      '• Ruotare il torso — fianchi e spalle paralleli al suolo\n'
      '• Tirare col bicipite — inizia portando la scapola verso la colonna vertebrale\n'
      '• Manubrio che va al petto — tira al fianco, gomito indietro\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando.',
      3, 8, 12),
  _pull('KB Row', 3, 'home', 'Gran dorsale, Romboidi', 'Bicipiti, Trapezio',
      'Busto a 45°. Kettlebell al fianco. Gomito vicino al corpo.',
      'Remata con kettlebell — impugnatura diversa dal manubrio per stimolo differente.\n\n'
      'PERCHÉ: L\'impugnatura del KB carica gli avambracci e cambia l\'angolo di trazione.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena arrotondata — mantieni schiena neutra, core attivo\n'
      '• Gomito che si apre — tienilo vicino al corpo\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando.',
      4, 6, 10),
  _pull('Weighted Row', 4, 'home', 'Gran dorsale, Romboidi', 'Bicipiti',
      'Manubri pesanti. Busto a 45°. Tira ai fianchi bilateralmente.',
      'Remata bilaterale con manubri pesanti — alternativa casalinga alla barbell row.\n\n'
      'PERCHÉ: Carico bilaterale pesante per massima forza di tirata senza bilanciere.\n\n'
      'ERRORI COMUNI:\n'
      '• Usare lo slancio del corpo — busto fermo, solo braccia\n'
      '• Schiena arrotondata — schiena neutra, core contratto\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando.',
      4, 6, 8),

  // Bodyweight
  _pull('Dead Hang', 1, 'bodyweight', 'Avambracci, Gran dorsale', 'Bicipiti',
      'Appeso alla sbarra, braccia distese. Scapole attive. Tenere.',
      'Sospensione passiva/attiva alla sbarra. Fondamento per tutti gli esercizi di tirata.\n\n'
      'PERCHÉ: Costruisce forza di presa, decomprime la colonna, prepara ai pull-up.\n\n'
      'ERRORI COMUNI:\n'
      '• Scapole completamente passive — attiva leggermente (deprimere le scapole) per proteggere le spalle\n'
      '• Trattenere il respiro — respira normalmente\n'
      '• Mollare subito — obiettivo: 30-60s. Se non ci arrivi, fai più set brevi\n\n'
      'RESPIRAZIONE: Respira normalmente, lento e controllato.',
      3, 20, 30),
  _pull('Australian Row', 2, 'bodyweight', 'Gran dorsale, Romboidi', 'Bicipiti',
      'Sbarra bassa, corpo inclinato sotto. Tira il petto alla sbarra.',
      'Remata orizzontale a corpo libero. Complemento perfetto ai push-up.\n\n'
      'PERCHÉ: Unico esercizio di tirata orizzontale senza attrezzi (serve solo una sbarra bassa).\n\n'
      'ERRORI COMUNI:\n'
      '• Corpo che cede — dritto come nel plank, glutei e core attivi\n'
      '• Non toccare la sbarra — il petto deve arrivare alla sbarra\n'
      '• Tirare col collo — porta il petto, non il mento\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando su.\n\n'
      'VARIANTE FACILITATA: Piedi più avanti (corpo più verticale) per ridurre il carico.',
      3, 8, 12),
  _pull('Pull-up Negatives', 3, 'bodyweight', 'Gran dorsale, Bicipiti', 'Core',
      'Salta sopra la sbarra. Scendi lentissimo (5s). Ripeti.',
      'Fase eccentrica del pull-up — il metodo più efficace per costruire la forza per il primo pull-up.\n\n'
      'PERCHÉ: I muscoli generano ~20-60% più forza in eccentrica. La fase negativa costruisce la forza concentrica.\n\n'
      'ERRORI COMUNI:\n'
      '• Scendere troppo veloce — MINIMO 3-5 secondi di discesa controllata\n'
      '• Saltare e basta — la discesa controllata È l\'esercizio\n'
      '• Non usare la presa prona — stessa presa del pull-up target\n\n'
      'RESPIRAZIONE: Inspira in alto, espira lentamente durante la discesa.',
      3, 5, 8),
  _pull('Pull-up BW', 4, 'bodyweight', 'Gran dorsale, Bicipiti', 'Trapezio, Core',
      'Presa prona. Mento sopra la sbarra. Scendi controllato.',
      'Pull-up a corpo libero completo — obiettivo intermedio nel percorso calistenico.\n\n'
      'PERCHÉ: Indicatore universale di forza relativa della parte superiore del corpo.\n\n'
      'ERRORI COMUNI:\n'
      '• Kipping — pull-up stretti senza slancio\n'
      '• ROM incompleta — da braccia distese a mento sopra la sbarra\n'
      '• Eccentrica veloce — scendi in 2-3s controllato\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando su.',
      4, 4, 8),
  _pull('Archer Pull-up', 5, 'bodyweight', 'Gran dorsale, Bicipiti', 'Core',
      'Un braccio tira, l\'altro si estende sulla sbarra. Alterna.',
      'Pull-up asimmetrico — preparazione al one-arm pull-up.\n\n'
      'PERCHÉ: Carica ~70-80% su un braccio, costruendo forza unilaterale.\n\n'
      'ERRORI COMUNI:\n'
      '• Braccio esteso che aiuta troppo — deve solo stabilizzare, non tirare\n'
      '• Oscillare — corpo fermo, core contratto\n\n'
      'RESPIRAZIONE: Inspira in basso, espira tirando su.\n\n'
      'VARIANTE FACILITATA: Pull-up standard o pull-up con presa mista.',
      4, 3, 5),
  _pull('Muscle-up BW', 6, 'bodyweight', 'Gran dorsale, Pettorali, Tricipiti', 'Core',
      'Pull-up esplosiva + transizione. Falsa presa aiuta la transizione.',
      'Muscle-up a corpo libero — apice della progressione di tirata calistenica.\n\n'
      'PERCHÉ: Combina forza di tirata e spinta in un singolo movimento fluido.\n\n'
      'ERRORI COMUNI:\n'
      '• No false grip — la presa "avvolta" sopra la sbarra è essenziale per la transizione\n'
      '• Pull-up verticale — la traiettoria deve curvare VERSO la sbarra, non dritta verso l\'alto\n'
      '• Tentare senza basi — servono 10+ pull-up esplosivi (petto alla sbarra)\n\n'
      'RESPIRAZIONE: Espira con forza nella fase esplosiva.',
      4, 2, 4),

  // -- Accessory pull --
  _pullAccessory('Bicep Curl', 'gym', 'Bicipiti', 'Avambracci',
      'Manubri o bilanciere. Gomiti fermi ai fianchi. Contrai in alto.',
      'Isolamento bicipiti. Complemento essenziale al lavoro di tirata composta.\n\n'
      'ERRORI COMUNI:\n'
      '• Gomiti che si muovono — devono restare fermi ai fianchi\n'
      '• Usare lo slancio — solo gli avambracci si muovono\n'
      '• Non controllare la discesa — 2-3s eccentrica\n\n'
      'RESPIRAZIONE: Inspira in basso, espira contraendo.',
      3, 10, 15),
  _pullAccessory('Rear Delt Fly', 'gym', 'Deltoidi posteriori', 'Romboidi',
      'Busto inclinato. Manubri leggeri, alza lateralmente. Stringi scapole.',
      'Isolamento deltoidi posteriori per bilanciare il volume di spinta.\n\n'
      'ERRORI COMUNI:\n'
      '• Troppo peso — usare carichi leggeri con controllo\n'
      '• Non stringere le scapole — pausa 1s alla massima contrazione\n'
      '• Usare lo slancio del busto — busto fermo, solo le braccia si muovono\n\n'
      'RESPIRAZIONE: Inspira in basso, espira alzando e stringendo le scapole.',
      3, 12, 15),

  // ============================================================
  // SQUAT (Lower Quad - Day 2)
  // ============================================================
  // Gym
  _squat('Leg Press', 1, 'gym', 'Quadricipiti, Glutei', 'Ischiocrurali',
      'Piedi larghezza spalle. Scendi fino a 90°. Non bloccare le ginocchia.',
      'Pressa per gambe — massimo carico sui quadricipiti in sicurezza.\n\n'
      'PERCHÉ: Permette di caricare le gambe pesantemente senza la complessità tecnica dello squat libero.\n\n'
      'ERRORI COMUNI:\n'
      '• Bloccare le ginocchia in estensione — leggera flessione sempre\n'
      '• Staccare la schiena dallo schienale — mantieni lombare aderente\n'
      '• Piedi troppo in basso — la piattaforma deve permettere 90° di flessione ginocchio\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira nella spinta.',
      3, 10, 15),
  _squat('Back Squat', 2, 'gym', 'Quadricipiti, Glutei', 'Core, Ischiocrurali',
      'Bilanciere sulle spalle. Scendi parallelo. Ginocchia in linea con i piedi.',
      'Il re degli esercizi per le gambe. Squat posteriore con bilanciere.\n\n'
      'PERCHÉ: Massimo reclutamento muscolare di tutta la catena inferiore. Stimola GH e testosterone. Base della forza atletica.\n\n'
      'ERRORI COMUNI:\n'
      '• Ginocchia che collassano in valgismo — spingi le ginocchia FUORI, nella direzione delle punte\n'
      '• Butt wink (bacino che ruota in fondo) — scendi fino a dove mantieni la lombare neutra\n'
      '• Peso sulle punte — spingi attraverso i talloni e il mesopiede\n\n'
      'RESPIRAZIONE: Inspira profondo prima di scendere (Valsalva), espira risalendo.\n\n'
      'VARIANTE FACILITATA: Goblet squat o leg press.',
      4, 6, 10),
  _squat('Front Squat', 3, 'gym', 'Quadricipiti, Core', 'Glutei',
      'Bilanciere alla clavicola. Gomiti alti. Busto verticale.',
      'Squat anteriore — enfatizza quadricipiti e core per la posizione verticale del busto.\n\n'
      'PERCHÉ: Busto più verticale = meno stress lombare. Maggiore attivazione quadricipiti rispetto al back squat.\n\n'
      'ERRORI COMUNI:\n'
      '• Gomiti che cadono — "gomiti ALTI" è il cue più importante. Se cadono, il bilanciere scivola\n'
      '• Mobilità polsi insufficiente — usare la presa a braccia incrociate come alternativa\n'
      '• Busto che si piega — se perdi la verticalità, riduci il carico\n\n'
      'RESPIRAZIONE: Inspira in alto, mantieni il core contratto durante la discesa, espira risalendo.',
      4, 6, 10),
  _squat('Pause Squat', 4, 'gym', 'Quadricipiti, Glutei', 'Core',
      'Back squat con pausa 2-3s in basso. Mantieni tensione.',
      'Squat con pausa in basso — elimina il rimbalzo elastico e sviluppa forza dal "buco".\n\n'
      'PERCHÉ: La pausa elimina lo stretch-shortening cycle, forzando i muscoli a generare forza concentrica pura.\n\n'
      'ERRORI COMUNI:\n'
      '• Rilassarsi nella pausa — mantieni TUTTA la tensione muscolare durante i 2-3s\n'
      '• Pausa troppo breve — conta "mille-uno, mille-due, mille-tre"\n'
      '• Stesso carico del back squat — usa 70-80% del carico normale\n\n'
      'RESPIRAZIONE: Inspira prima di scendere, trattieni durante la pausa, espira risalendo.',
      4, 4, 8),
  _squat('ATG Squat', 5, 'gym', 'Quadricipiti, Glutei', 'Core, Mobilità caviglia',
      'Squat completo "ass to grass". Bilanciere leggero. Massima ROM.',
      'Squat a ROM completa — scendere il più basso possibile mantenendo la forma.\n\n'
      'PERCHÉ: ROM completa = +20% reclutamento muscolare rispetto al parallelo. Le ginocchia che superano le punte sono sicure (Schoenfeld 2010, Hartmann 2013).\n\n'
      'ERRORI COMUNI:\n'
      '• Forzare la profondità con butt wink — scendi solo fino a dove la lombare resta neutra\n'
      '• Troppo carico — la ROM completa richiede carichi inferiori\n'
      '• Mobilità caviglia insufficiente — talloni su rialzo 1-2cm o scarpe da squat\n\n'
      'RESPIRAZIONE: Inspira in alto, Valsalva durante la discesa, espira risalendo.',
      4, 4, 6),
  _squat('Olympic Squat', 6, 'gym', 'Quadricipiti, Glutei', 'Core, Catena posteriore',
      'Squat con tecnica olimpica. Tacchi rialzati. Busto verticale. Massima profondità.',
      'Squat con tecnica da pesistica olimpica — massima profondità e verticalità del busto.\n\n'
      'PERCHÉ: Tecnica usata dai pesisti per la massima profondità e il recupero dal clean. Richiede mobilità eccellente.\n\n'
      'ERRORI COMUNI:\n'
      '• Senza scarpe adeguate — tacchi rialzati (scarpe da pesistica) sono praticamente obbligatori\n'
      '• Tentare senza mobilità — prerequisito: ATG squat pulito con carico leggero\n'
      '• Ginocchia che collassano — spingi fuori attivamente\n\n'
      'RESPIRAZIONE: Valsalva durante tutto il movimento.\n\n'
      'VARIANTE FACILITATA: ATG Squat con bilanciere leggero.',
      4, 3, 5),

  // Home
  _squat('Goblet Squat', 1, 'home', 'Quadricipiti, Glutei', 'Core',
      'Manubrio/KB al petto. Gomiti tra le ginocchia. Scendi profondo.',
      'Squat con peso al petto — il miglior esercizio per imparare lo squat corretto.\n\n'
      'PERCHÉ: Il peso davanti forza il busto verticale e insegna naturalmente il pattern motorio corretto.\n\n'
      'ERRORI COMUNI:\n'
      '• Gomiti che escono dalle ginocchia — usali come guide per spingere le ginocchia fuori\n'
      '• Non scendere abbastanza — la profondità è l\'obiettivo, non il carico\n'
      '• Peso troppo lontano dal petto — tienilo aderente\n\n'
      'RESPIRAZIONE: Inspira in alto, espira risalendo.',
      3, 10, 15),
  _squat('DB Squat', 2, 'home', 'Quadricipiti, Glutei', 'Core',
      'Manubri ai fianchi. Scendi parallelo. Petto in fuori.',
      'Squat con manubri ai lati. Buona alternativa casalinga al back squat.\n\n'
      'PERCHÉ: Carico distribuito ai lati permette carichi maggiori del goblet squat.\n\n'
      'ERRORI COMUNI:\n'
      '• Busto che si piega avanti — petto in fuori, sguardo avanti\n'
      '• Manubri che oscillano — tienili fermi ai fianchi\n'
      '• Ginocchia in valgismo — stessa tecnica del back squat\n\n'
      'RESPIRAZIONE: Inspira nella discesa, espira risalendo.',
      3, 8, 12),
  _squat('Bulgarian Split Squat DB', 3, 'home', 'Quadricipiti, Glutei', 'Core, Equilibrio',
      'Piede posteriore su rialzo. Manubri ai fianchi. Scendi con il ginocchio a 90°.',
      'Split squat bulgaro con manubri — esercizio unilaterale avanzato per gambe e glutei.\n\n'
      'PERCHÉ: Lavoro unilaterale + stretch attivo del flessore dell\'anca. Corregge asimmetrie.\n\n'
      'ERRORI COMUNI:\n'
      '• Piede anteriore troppo vicino al rialzo — serve distanza sufficiente per 90° al ginocchio\n'
      '• Ginocchio che supera troppo la punta — va bene leggermente, ma controlla\n'
      '• Perdere l\'equilibrio — fissa un punto, core attivo, piede anteriore stabile\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      4, 6, 10),
  _squat('Pistol Progression', 4, 'home', 'Quadricipiti, Glutei', 'Core, Equilibrio',
      'Squat su una gamba con supporto (TRX/sedia). Gamba avanti estesa.',
      'Progressione verso il pistol squat usando un supporto per assistenza.\n\n'
      'PERCHÉ: Costruisce la forza unilaterale e l\'equilibrio necessari per il pistol squat completo.\n\n'
      'ERRORI COMUNI:\n'
      '• Troppa assistenza dal supporto — usalo il meno possibile\n'
      '• Ginocchio che collassa — spingi il ginocchio nella direzione della punta\n'
      '• Tallone che si alza — tutto il piede a terra\n\n'
      'RESPIRAZIONE: Inspira in alto, espira risalendo.',
      4, 4, 8),

  // Bodyweight
  _squat('Assisted Squat', 1, 'bodyweight', 'Quadricipiti, Glutei', 'Core',
      'Tieniti a un supporto. Scendi profondo. Torna su spingendo coi talloni.',
      'Squat assistito — primo step per chi non riesce a fare squat profondi senza supporto.\n\n'
      'PERCHÉ: Il supporto permette di raggiungere profondità impossibili senza assistenza, migliorando mobilità.\n\n'
      'ERRORI COMUNI:\n'
      '• Tirare troppo col supporto — usalo il meno possibile, solo per equilibrio\n'
      '• Non scendere abbastanza — l\'obiettivo è la massima profondità\n'
      '• Ginocchia in valgismo — spingi fuori\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      3, 12, 20),
  _squat('Bodyweight Squat', 2, 'bodyweight', 'Quadricipiti, Glutei', 'Core',
      'Piedi larghezza spalle. Braccia avanti. Scendi parallelo.',
      'Squat a corpo libero — fondamentale del fitness funzionale.\n\n'
      'PERCHÉ: Pattern motorio primario dell\'essere umano. Piedi larghezza spalle, punte ruotate 15-30°.\n\n'
      'ERRORI COMUNI:\n'
      '• Ginocchia che collassano — devono puntare nella STESSA DIREZIONE delle punte dei piedi\n'
      '• Non scendere sotto il parallelo — senza carico, il full depth è sicuro e superiore per reclutamento (+20%)\n'
      '• Peso sulle punte — spingi con talloni e mesopiede\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      3, 10, 15),
  _squat('Bulgarian Split Squat BW', 3, 'bodyweight', 'Quadricipiti, Glutei', 'Core, Equilibrio',
      'Piede posteriore su rialzo. Scendi con il ginocchio a 90°. Busto dritto.',
      'Split squat bulgaro a corpo libero. Versione unilaterale senza pesi.\n\n'
      'PERCHÉ: Ottimo per principianti che vogliono iniziare il lavoro unilaterale prima di aggiungere carico.\n\n'
      'ERRORI COMUNI:\n'
      '• Rialzo troppo alto — una sedia o un divano vanno bene, niente di più alto\n'
      '• Busto che cade avanti — petto in fuori, sguardo avanti\n'
      '• Ginocchio che cede in valgismo — spingi fuori attivamente\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      3, 8, 12),
  _squat('Shrimp Squat', 4, 'bodyweight', 'Quadricipiti, Glutei', 'Core, Equilibrio',
      'Su una gamba, piede posteriore afferrato. Ginocchio posteriore a terra.',
      'Squat gamberetto — variante unilaterale che richiede forza e mobilità.\n\n'
      'PERCHÉ: Alternativa al pistol squat che enfatizza i quadricipiti con meno richiesta di mobilità caviglia.\n\n'
      'ERRORI COMUNI:\n'
      '• Ginocchio posteriore che sbatte a terra — scendi controllato, tocca leggero\n'
      '• Perdere la presa del piede — afferra saldamente la caviglia dietro\n'
      '• Busto troppo avanti — mantieni il busto il più verticale possibile\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.\n\n'
      'VARIANTE FACILITATA: Bulgarian split squat BW.',
      4, 4, 8),
  _squat('Pistol Squat', 5, 'bodyweight', 'Quadricipiti, Glutei', 'Core, Equilibrio, Mobilità',
      'Squat completo su una gamba. Gamba avanti estesa. Tallone a terra.',
      'Pistol squat — l\'esercizio unilaterale di riferimento nel calisthenics.\n\n'
      'PERCHÉ: Dimostra forza, equilibrio e mobilità eccezionali. Carico equivalente a ~1.5x peso corporeo su una gamba.\n\n'
      'ERRORI COMUNI:\n'
      '• Tallone che si alza — mobilità caviglia insufficiente. Metti un rialzo sotto il tallone come assistenza\n'
      '• Gamba avanti che cade — flessori dell\'anca deboli. Allena L-sit e leg raises\n'
      '• Ginocchio che cede — spingi fuori durante tutta la discesa\n\n'
      'RESPIRAZIONE: Inspira in alto, espira risalendo.\n\n'
      'VARIANTE FACILITATA: Pistol progression con supporto (TRX/sedia).',
      4, 3, 5),
  _squat('Weighted Pistol', 6, 'bodyweight', 'Quadricipiti, Glutei', 'Core, Equilibrio',
      'Pistol squat con peso (manubrio al petto o gilet zavorrato).',
      'Pistol squat zavorrato — progressione oltre il corpo libero.\n\n'
      'PERCHÉ: Quando il pistol a corpo libero diventa "facile" (5+ rep), il peso aggiuntivo continua la progressione.\n\n'
      'ERRORI COMUNI:\n'
      '• Troppo peso — inizia con 2-5kg, il contrappeso al petto può aiutare l\'equilibrio\n'
      '• Perdere la forma — stessi standard del pistol a corpo libero\n\n'
      'RESPIRAZIONE: Inspira in alto, espira risalendo.',
      4, 2, 4),

  // -- Accessory squat --
  _squatAccessory('Leg Extension', 'gym', 'Quadricipiti', '',
      'Alla macchina. Estendi completamente. Contrai in alto 1s.',
      'Isolamento quadricipiti alla macchina. Ottimo per pre-affaticamento o finisher.\n\n'
      'ERRORI COMUNI:\n'
      '• Usare lo slancio — movimento lento e controllato\n'
      '• Non estendere completamente — contrai i quadricipiti al massimo in alto\n'
      '• Troppo peso — questo è un esercizio di isolamento, non di forza massimale\n\n'
      'RESPIRAZIONE: Inspira nella flessione, espira nell\'estensione.',
      3, 10, 15),
  _squatAccessory('Calf Raise', 'all', 'Polpacci', '',
      'Su rialzo, talloni oltre il bordo. Sali sulla punta. 2s pausa in alto.',
      'Calf raise su rialzo per ROM completa dei polpacci.\n\n'
      'ERRORI COMUNI:\n'
      '• ROM incompleta — scendi con i talloni sotto il bordo per stretch completo\n'
      '• Rimbalzare — pausa 2s in alto per eliminare l\'elasticità tendinea\n'
      '• Ginocchia piegate — gambe dritte per soleus, leggermente piegate per gastrocnemio\n\n'
      'RESPIRAZIONE: Inspira in basso, espira salendo.',
      3, 12, 20),
  _squatAccessory('Lunges', 'all', 'Quadricipiti, Glutei', 'Core',
      'Passo avanti lungo. Ginocchio posteriore sfiora terra. Alterna.',
      'Affondi — esercizio funzionale per gambe e stabilità.\n\n'
      'ERRORI COMUNI:\n'
      '• Passo troppo corto — il ginocchio anteriore non deve superare di molto la punta\n'
      '• Ginocchio posteriore che sbatte — sfiora il pavimento, non sbattere\n'
      '• Oscillare lateralmente — core attivo, movimento lineare\n\n'
      'RESPIRAZIONE: Inspira durante il passo, espira risalendo.',
      3, 8, 12),

  // ============================================================
  // HINGE (Lower Hip - Day 5)
  // ============================================================
  // Gym
  _hinge('Leg Curl', 1, 'gym', 'Ischiocrurali', 'Polpacci',
      'Alla macchina. Fletti le ginocchia completamente. 3s eccentrica.',
      'Isolamento ischiocrurali alla macchina. Fondamentale per prevenzione infortuni hamstring.\n\n'
      'PERCHÉ: Isolamento diretto degli hamstring che bilancia il lavoro dominante dei quadricipiti.\n\n'
      'ERRORI COMUNI:\n'
      '• Alzare i fianchi dalla panca — resta aderente, solo le ginocchia si flettono\n'
      '• Eccentrica veloce — 3s di discesa controllata per massimo stimolo\n'
      '• ROM incompleta — fletti completamente e estendi quasi completamente\n\n'
      'RESPIRAZIONE: Inspira in estensione, espira nella flessione.',
      3, 10, 15),
  _hinge('Romanian Deadlift', 2, 'gym', 'Ischiocrurali, Glutei', 'Erettori spinali',
      'Bilanciere, scendi con schiena neutra. Ginocchia leggermente flesse.',
      'Stacco rumeno — il fondamentale per hamstring e glutei con pattern hip hinge.\n\n'
      'PERCHÉ: Massimo stretch sotto carico degli hamstring. Eccellente per prevenzione infortuni e forza della catena posteriore.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena arrotondata — SCHIENA NEUTRA in ogni momento. Se la perdi, riduci il carico\n'
      '• Ginocchia che si piegano troppo — leggera flessione fissa, non fare uno squat\n'
      '• Bilanciere lontano dal corpo — il bilanciere deve "accarezzare" le cosce durante tutto il movimento\n\n'
      'RESPIRAZIONE: Inspira in alto, espira nella discesa mantenendo il core contratto.\n\n'
      'VARIANTE FACILITATA: DB RDL con manubri leggeri.',
      4, 6, 10),
  _hinge('Conventional Deadlift', 3, 'gym', 'Glutei, Ischiocrurali, Erettori', 'Quadricipiti, Core',
      'Piedi sotto la sbarra. Schiena neutra. Spingi col pavimento.',
      'Stacco da terra convenzionale — l\'esercizio con il massimo carico assoluto.\n\n'
      'PERCHÉ: Recluta più muscoli di qualsiasi altro esercizio. Forza totale del corpo.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena arrotondata — "petto in fuori, schiena piatta" PRIMA di tirare\n'
      '• Tirare con le braccia — le braccia sono cavi. Spingi il PAVIMENTO con i piedi\n'
      '• Sbarra lontana — deve partire sopra il mesopiede, vicina alle tibie\n\n'
      'RESPIRAZIONE: Inspira profondo prima di tirare (Valsalva), espira al lockout.\n\n'
      'VARIANTE FACILITATA: Romanian Deadlift per apprendere il pattern.',
      4, 5, 8),
  _hinge('Sumo Deadlift', 4, 'gym', 'Glutei, Adduttori, Ischiocrurali', 'Quadricipiti',
      'Piedi larghi, punte fuori. Presa stretta. Spingi le ginocchia fuori.',
      'Stacco sumo — piedi larghi, presa stretta. Enfatizza glutei e adduttori.\n\n'
      'PERCHÉ: ROM ridotta rispetto al convenzionale, posizione più verticale del busto, meno stress lombare.\n\n'
      'ERRORI COMUNI:\n'
      '• Ginocchia che collassano — spingi FUORI attivamente durante tutta la tirata\n'
      '• Fianchi che salgono prima delle spalle — "spingi il pavimento, non tirare la sbarra"\n'
      '• Piedi troppo larghi — larghezza tale da mantenere le tibie verticali\n\n'
      'RESPIRAZIONE: Valsalva prima di tirare, espira al lockout.',
      4, 4, 6),
  _hinge('Deficit Deadlift', 5, 'gym', 'Glutei, Ischiocrurali', 'Core, Quadricipiti',
      'In piedi su rialzo 5-10cm. Deadlift convenzionale con maggiore ROM.',
      'Stacco da deficit — aumenta la ROM per sviluppare forza dalla posizione più bassa.\n\n'
      'PERCHÉ: Rafforza la fase iniziale dello stacco (la più debole per molti). Maggiore stretch degli hamstring.\n\n'
      'ERRORI COMUNI:\n'
      '• Rialzo troppo alto — 5-10cm è sufficiente. Troppo alto compromette la tecnica\n'
      '• Stessa tecnica ma con schiena arrotondata — se non riesci a mantenere la schiena neutra, riduci il deficit\n\n'
      'RESPIRAZIONE: Valsalva prima di tirare, espira al lockout.',
      4, 3, 5),
  _hinge('Snatch Grip Deadlift', 6, 'gym', 'Dorsali, Glutei, Ischiocrurali', 'Trapezio, Core',
      'Presa snatch (molto larga). Schiena piatta. Massima attivazione dorsale.',
      'Stacco con presa snatch — presa molto larga che aumenta la ROM e l\'attivazione dorsale.\n\n'
      'PERCHÉ: La presa larga costringe a una posizione più bassa, attivando massimamente dorsali e trapezio.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena arrotondata — la posizione bassa è più impegnativa, riduci il carico\n'
      '• Presa insufficiente — usa gesso o straps se necessario per la presa larga\n'
      '• Non deprimere le scapole — "scapole in tasca" per proteggere le spalle\n\n'
      'RESPIRAZIONE: Valsalva prima di tirare, espira al lockout.',
      4, 3, 5),

  // Home
  _hinge('KB Deadlift', 1, 'home', 'Glutei, Ischiocrurali', 'Core',
      'Kettlebell tra i piedi. Schiena neutra. Hip hinge. Stringi i glutei in alto.',
      'Stacco con kettlebell — introduzione al pattern hip hinge con attrezzo casalingo.\n\n'
      'PERCHÉ: Il KB tra i piedi insegna naturalmente il pattern corretto dell\'hip hinge.\n\n'
      'ERRORI COMUNI:\n'
      '• Fare uno squat invece di un hinge — le anche vanno INDIETRO, non giù\n'
      '• Schiena arrotondata — petto in fuori, schiena piatta\n'
      '• Non stringere i glutei al lockout — completa il movimento stringendo forte\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      3, 10, 15),
  _hinge('DB RDL', 2, 'home', 'Ischiocrurali, Glutei', 'Erettori spinali',
      'Manubri lungo le cosce. Schiena neutra. Scendi fino a sentire allungamento.',
      'Stacco rumeno con manubri — versione casalinga dell\'RDL con bilanciere.\n\n'
      'PERCHÉ: Stesso pattern della versione con bilanciere, più accessibile per chi si allena a casa.\n\n'
      'ERRORI COMUNI:\n'
      '• Manubri lontani dal corpo — devono "accarezzare" le cosce\n'
      '• Scendere troppo — fermati quando senti stretch negli hamstring (tipicamente metà tibia)\n'
      '• Ginocchia che si piegano — leggera flessione fissa\n\n'
      'RESPIRAZIONE: Inspira in alto, espira scendendo con core attivo.',
      3, 8, 12),
  _hinge('KB Swing', 3, 'home', 'Glutei, Ischiocrurali', 'Core, Deltoidi',
      'Kettlebell tra le gambe. Hip hinge esplosivo. Braccia passive.',
      'Swing con kettlebell — esercizio balistico per potenza della catena posteriore.\n\n'
      'PERCHÉ: Unico esercizio che combina potenza esplosiva dell\'hip hinge con condizionamento cardiovascolare.\n\n'
      'ERRORI COMUNI:\n'
      '• Fare uno squat swing — è un HIP HINGE. Le anche vanno indietro, non giù\n'
      '• Sollevare con le braccia — le braccia sono PASSIVE. La potenza viene dai glutei\n'
      '• Iperestendere la schiena in alto — al lockout, corpo dritto, glutei stretti\n\n'
      'RESPIRAZIONE: Inspira nella discesa (hinge), espira con forza durante lo snap dei fianchi.\n\n'
      'VARIANTE FACILITATA: KB Deadlift per apprendere l\'hip hinge prima.',
      4, 10, 15),
  _hinge('Single Leg RDL', 4, 'home', 'Ischiocrurali, Glutei', 'Core, Equilibrio',
      'Su una gamba. Manubrio nella mano opposta. Schiena neutra.',
      'Stacco rumeno su una gamba — esercizio unilaterale per hamstring, glutei e equilibrio.\n\n'
      'PERCHÉ: Corregge asimmetrie, allena l\'equilibrio, e isola ogni gamba indipendentemente.\n\n'
      'ERRORI COMUNI:\n'
      '• Fianchi che ruotano — mantieni i fianchi paralleli al suolo\n'
      '• Ginocchio della gamba d\'appoggio bloccato — leggera flessione\n'
      '• Gamba posteriore non allineata — sale dritta come continuazione della schiena\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.\n\n'
      'VARIANTE FACILITATA: DB RDL bilaterale.',
      4, 6, 8),

  // Bodyweight
  _hinge('Glute Bridge', 1, 'bodyweight', 'Glutei', 'Ischiocrurali, Core',
      'Sdraiato, piedi a terra. Spingi i fianchi su. Stringi i glutei in alto.',
      'Ponte gluteo — fondamentale per attivare e rafforzare i glutei.\n\n'
      'PERCHÉ: Attiva i glutei in isolamento. Corregge l\'inibizione glutea causata dalla vita sedentaria.\n\n'
      'ERRORI COMUNI:\n'
      '• Iperestendere la lombare — fai POSTERIOR PELVIC TILT (appiattisci la lombare) PRIMA di sollevare\n'
      '• Non stringere i glutei — stringi forte in alto, mantieni 1-2s\n'
      '• Piedi troppo vicini o lontani — circa un piede dai glutei\n\n'
      'RESPIRAZIONE: Inspira a terra, espira sollevando e stringendo i glutei.',
      3, 12, 20),
  _hinge('Single Leg Bridge', 2, 'bodyweight', 'Glutei', 'Ischiocrurali, Core',
      'Come glute bridge ma su una gamba sola. L\'altra estesa.',
      'Ponte gluteo unilaterale — progressione dal glute bridge bilaterale.\n\n'
      'PERCHÉ: Raddoppia il carico per gluteo. Corregge asimmetrie tra i due lati.\n\n'
      'ERRORI COMUNI:\n'
      '• Fianchi che cadono da un lato — mantieni il bacino orizzontale\n'
      '• Gamba libera che spinge — la gamba estesa è passiva\n'
      '• Perdere il posterior pelvic tilt — stessa tecnica del bridge bilaterale\n\n'
      'RESPIRAZIONE: Inspira a terra, espira sollevando.',
      3, 8, 12),
  _hinge('Nordic Curl Negative', 3, 'bodyweight', 'Ischiocrurali', 'Glutei, Core',
      'In ginocchio, piedi bloccati. Scendi lentissimo (5s). Mani a terra per risalire.',
      'Nordic curl eccentrica — il singolo miglior esercizio per la prevenzione degli infortuni hamstring (-51% infortuni, meta-analisi).\n\n'
      'PERCHÉ: Gli hamstring lavorano in eccentrica al massimo stretch. La fase eccentrica È l\'esercizio.\n\n'
      'ERRORI COMUNI:\n'
      '• Piegare alla vita — stringi glutei per BLOCCARE LE ANCHE in posizione neutra/estesa. Questo è il cue di sicurezza più importante\n'
      '• Scendere troppo veloce — MINIMO 3-5 secondi di discesa controllata\n'
      '• Tentare senza basi — classificato "alta complessità" (fonti RU). Solo dopo 6+ mesi di allenamento regolare\n\n'
      'RESPIRAZIONE: Inspira in alto, espira lentamente durante la discesa.\n\n'
      'VARIANTE FACILITATA: Glute bridge → Single leg bridge → poi nordic negative con range parziale.',
      3, 4, 6),
  _hinge('Nordic Curl', 4, 'bodyweight', 'Ischiocrurali', 'Glutei, Core',
      'In ginocchio, piedi bloccati. Scendi e risali controllato.',
      'Nordic curl completo — eccentrica E concentrica controllate. Obiettivo avanzato.\n\n'
      'PERCHÉ: Forza eccentrica E concentrica degli hamstring in range estremo.\n\n'
      'ERRORI COMUNI:\n'
      '• Piegare alla vita — glutei stretti, anche estese per TUTTO il movimento\n'
      '• Concentrica con slancio — risalita controllata usando solo gli hamstring\n'
      '• Range incompleto — se non riesci a risalire dal basso, torna alle negative\n\n'
      'RESPIRAZIONE: Inspira in alto, espira controllato nella discesa e nella risalita.',
      4, 3, 6),
  _hinge('Single Leg Nordic', 5, 'bodyweight', 'Ischiocrurali', 'Glutei, Core',
      'Nordic curl su una gamba. Massima difficoltà.',
      'Nordic curl su una gamba — esercizio di élite per hamstring.\n\n'
      'PERCHÉ: Massima richiesta su un singolo hamstring. Solo per atleti avanzati.\n\n'
      'ERRORI COMUNI:\n'
      '• Tentare senza padroneggiare il bilaterale — servono 8+ nordic curl bilaterali puliti\n'
      '• Perdere la posizione delle anche — stessi standard del nordic bilaterale\n\n'
      'RESPIRAZIONE: Inspira in alto, espira nella discesa controllata.',
      4, 2, 4),
  _hinge('Full Nordic Curl', 6, 'bodyweight', 'Ischiocrurali', 'Glutei, Core',
      'Nordic curl completo con ROM piena. Eccentrica e concentrica controllate.',
      'Nordic curl a ROM completa — padronanza totale del pattern con controllo in ogni fase.\n\n'
      'PERCHÉ: Indica padronanza eccezionale della forza degli hamstring. Protezione massima dagli infortuni.\n\n'
      'ERRORI COMUNI:\n'
      '• Forma degradata per completare la ROM — la qualità supera la quantità\n'
      '• Ignorare il dolore — distinguere tra sforzo muscolare e dolore articolare\n\n'
      'RESPIRAZIONE: Respira con controllo durante tutto il movimento.',
      4, 2, 3),

  // -- Accessory hinge --
  _hingeAccessory('Hip Thrust', 'gym', 'Glutei', 'Ischiocrurali',
      'Schiena su panca. Bilanciere sui fianchi. Spingi su, stringi glutei.',
      'Hip thrust con bilanciere — l\'esercizio che carica di più i glutei in isolamento.\n\n'
      'ERRORI COMUNI:\n'
      '• Iperestendere la lombare — fermarsi quando fianchi sono allineati con spalle e ginocchia\n'
      '• Non stringere i glutei — contrazione forte in alto, 1-2s\n'
      '• Bilanciere che rotola — usa un pad per proteggere le anche\n\n'
      'RESPIRAZIONE: Inspira in basso, espira spingendo su.',
      3, 8, 12),
  _hingeAccessory('Back Extension', 'gym', 'Erettori spinali, Glutei', 'Ischiocrurali',
      'Alla panca romana. Scendi a 90°. Risali con glutei e erettori.',
      'Iperestensione alla panca romana per erettori spinali e glutei.\n\n'
      'ERRORI COMUNI:\n'
      '• Iperestendere oltre la linea neutra — fermati quando il corpo è dritto\n'
      '• Usare solo gli erettori — stringi i glutei per iniziare la risalita\n'
      '• Slancio — movimento lento e controllato, 2s in ogni fase\n\n'
      'RESPIRAZIONE: Inspira scendendo, espira risalendo.',
      3, 10, 15),

  // ============================================================
  // CORE (all days, 2-3 exercises)
  // ============================================================
  _core('Dead Bug', 1, 'Core, Trasverso addominale', '',
      'Sdraiato, braccia e gambe in aria. Allunga braccio+gamba opposti. Schiena a terra.',
      'Esercizio anti-estensione che insegna la stabilità del core mantenendo la lombare a terra.\n\n'
      'PERCHÉ: Allena il trasverso addominale e la coordinazione controlaterale. Base della stabilità del core.\n\n'
      'ERRORI COMUNI:\n'
      '• Lombare che si stacca dal pavimento — la schiena deve restare PIATTA a terra. Se si stacca, riduci il range\n'
      '• Movimenti troppo veloci — lento e controllato, 2-3s per estensione\n'
      '• Trattenere il fiato — respira normalmente durante tutto il movimento\n\n'
      'RESPIRAZIONE: Espira estendendo braccio e gamba, inspira tornando.'),
  _core('Bird Dog', 1, 'Core, Erettori spinali', '',
      'A quattro zampe. Allunga braccio+gamba opposti. 2s pausa in estensione.',
      'Esercizio anti-rotazione e anti-estensione in posizione quadrupedica.\n\n'
      'PERCHÉ: Allena la stabilità del core contro la rotazione. Rafforza gli erettori spinali in modo sicuro.\n\n'
      'ERRORI COMUNI:\n'
      '• Ruotare i fianchi — il bacino non deve ruotare quando estendi la gamba\n'
      '• Inarcare la schiena — mantieni la colonna neutra, come con un bicchiere d\'acqua sulla schiena\n'
      '• Nessuna pausa — 2s di tenuta in estensione per massima attivazione\n\n'
      'RESPIRAZIONE: Inspira nella posizione iniziale, espira estendendo.'),
  _core('Plank', 2, 'Core, Trasverso addominale', 'Deltoidi, Glutei',
      'Avambracci e punte dei piedi. Corpo dritto. Attiva core e glutei.',
      'Plank frontale — il fondamentale isometrico del core.\n\n'
      'PERCHÉ: Allena il core in anti-estensione con tutto il peso corporeo. Gomiti sotto le spalle.\n\n'
      'ERRORI COMUNI:\n'
      '• Anche che cedono o si alzano — stringi glutei e RUOTA LEGGERMENTE IL BACINO SOTTO (posterior pelvic tilt)\n'
      '• Trattenere il fiato — respira: inspira dal naso, espira dalla bocca. NON trattenere (causa aumento pressione, vertigini — fonti RU)\n'
      '• Guardare avanti — sguardo a terra per mantenere la colonna cervicale neutra\n\n'
      'RESPIRAZIONE: Respira normalmente. Inspiro lento dal naso, espiro controllato dalla bocca.'),
  _core('Side Plank', 2, 'Obliqui, Core', 'Glutei',
      'Su un avambraccio. Corpo dritto, fianchi alti. Non ruotare.',
      'Plank laterale — isometrico per obliqui e stabilità laterale.\n\n'
      'PERCHÉ: Allena la resistenza alla flessione laterale. Fondamentale per la salute della colonna.\n\n'
      'ERRORI COMUNI:\n'
      '• Fianchi che cedono — mantieni i fianchi ALTI, corpo dritto\n'
      '• Ruotare in avanti o indietro — corpo perfettamente laterale\n'
      '• Spalla che soffre — gomito direttamente sotto la spalla\n\n'
      'RESPIRAZIONE: Respira normalmente mantenendo la posizione.'),
  _core('Ab Wheel (knees)', 3, 'Retto addominale, Core', 'Dorsali',
      'In ginocchio. Rotola avanti con la ruota. Torna indietro contraendo.',
      'Rollout con ab wheel dalle ginocchia — potente esercizio anti-estensione.\n\n'
      'PERCHÉ: Eccellente attivazione del retto addominale e del core in un pattern di anti-estensione dinamica.\n\n'
      'ERRORI COMUNI:\n'
      '• Lombare che iper-estende — mantieni il posterior pelvic tilt durante TUTTO il movimento\n'
      '• Andare troppo avanti — solo fino a dove mantieni il controllo lombare\n'
      '• Braccia piegate — braccia distese, il movimento è tutto nel core\n\n'
      'RESPIRAZIONE: Inspira rotolando avanti, espira contraendo per tornare.'),
  _core('Pallof Press', 3, 'Obliqui, Trasverso', 'Core',
      'Cavo laterale, braccia al petto. Spingi avanti resistendo alla rotazione.',
      'Pallof press — anti-rotazione con cavo o elastico.\n\n'
      'PERCHÉ: Allena specificamente la capacità del core di resistere alla rotazione. Eccellente per la salute lombare.\n\n'
      'ERRORI COMUNI:\n'
      '• Ruotare verso il cavo — il torso deve restare perfettamente frontale\n'
      '• Usare troppo peso — questo è un esercizio di stabilità, non di forza\n'
      '• Braccia piegate — estendi completamente davanti al petto\n\n'
      'RESPIRAZIONE: Inspira al petto, espira spingendo avanti e resistendo.'),
  _core('Hanging Knee Raise', 4, 'Retto addominale', 'Flessori anca',
      'Appeso alla sbarra. Porta le ginocchia al petto. Scendi controllato.',
      'Sollevamento ginocchia alla sbarra — esercizio avanzato per la parte bassa degli addominali.\n\n'
      'PERCHÉ: Allena il retto addominale nella sua funzione primaria: flessione del bacino verso il petto.\n\n'
      'ERRORI COMUNI:\n'
      '• Oscillare — corpo fermo, zero slancio\n'
      '• Solo flessione dell\'anca — il cue è portare il BACINO verso il petto, non solo le ginocchia\n'
      '• Scendere di scatto — eccentrica controllata 2-3s\n\n'
      'RESPIRAZIONE: Inspira appeso, espira sollevando le ginocchia.'),
  _core('Ab Wheel Standing', 4, 'Retto addominale, Core', 'Dorsali, Deltoidi',
      'In piedi. Rotola avanti con la ruota fino quasi a terra. Torna su.',
      'Rollout con ab wheel in piedi — versione avanzata che richiede forza estrema del core.\n\n'
      'PERCHÉ: ROM molto maggiore rispetto alla versione dalle ginocchia. Massima attivazione del retto addominale.\n\n'
      'ERRORI COMUNI:\n'
      '• Lombare che cede — se la lombare iper-estende, torna alla versione dalle ginocchia\n'
      '• Tentare senza basi — servono 15+ rollout dalle ginocchia con forma perfetta\n'
      '• Braccia piegate — braccia distese, tutto il movimento è dal core\n\n'
      'RESPIRAZIONE: Inspira rotolando avanti, espira tornando.\n\n'
      'VARIANTE FACILITATA: Ab wheel dalle ginocchia.'),
  _core('Dragon Flag Negative', 5, 'Retto addominale, Core', 'Dorsali',
      'Sdraiato su panca, mani dietro la testa. Solleva corpo rigido, scendi lento.',
      'Dragon flag eccentrica — esercizio leggendario reso famoso da Bruce Lee.\n\n'
      'PERCHÉ: Massima richiesta isometrica/eccentrica su tutto il core come unità unica.\n\n'
      'ERRORI COMUNI:\n'
      '• Corpo non rigido — devi essere una TAVOLA rigida dalla testa ai piedi\n'
      '• Scendere troppo veloce — eccentrica di 5-8s\n'
      '• Inarcare la lombare — posterior pelvic tilt attivo\n\n'
      'RESPIRAZIONE: Inspira in alto, espira lentamente durante la discesa.'),
  _core('L-sit', 5, 'Core, Flessori anca', 'Quadricipiti, Tricipiti',
      'Su parallettes o pavimento. Gambe dritte parallele al suolo. Tenere.',
      'L-sit — isometrico avanzato che richiede forza del core, flessori dell\'anca e tricipiti.\n\n'
      'PERCHÉ: Allena la compressione (core + flessori anca) in isometria. Prerequisito per molte skill calisteniche.\n\n'
      'ERRORI COMUNI:\n'
      '• Gambe piegate — estendi completamente. Se impossibile, inizia con una gamba alla volta\n'
      '• Spalle che salgono alle orecchie — deprimi le scapole\n'
      '• Trattenere il fiato — respira normalmente\n\n'
      'RESPIRAZIONE: Respira normalmente mantenendo la posizione.\n\n'
      'VARIANTE FACILITATA: Tuck L-sit (ginocchia piegate al petto).'),
  _core('Dragon Flag', 6, 'Retto addominale, Core', 'Dorsali',
      'Dragon flag completa: su e giù controllato. Corpo rigido come una tavola.',
      'Dragon flag completa — eccentrica e concentrica. Elite del core training.\n\n'
      'PERCHÉ: Controllo totale del core in un range estremo. Pochi esercizi eguagliano questa richiesta.\n\n'
      'ERRORI COMUNI:\n'
      '• Forma degradata per completare le reps — qualità > quantità\n'
      '• Lombare che cede — se non puoi mantenere la rigidità, torna alle negative\n\n'
      'RESPIRAZIONE: Espira salendo, inspira nella fase di discesa controllata.'),
  _core('Front Lever Progression', 6, 'Dorsali, Core', 'Bicipiti',
      'Appeso alla sbarra, corpo parallelo al suolo. Tenere la posizione.',
      'Progressione front lever — skill calistenica di élite per core e dorsali.\n\n'
      'PERCHÉ: Richiede forza isometrica estrema di dorsali e core. Obiettivo a lungo termine.\n\n'
      'ERRORI COMUNI:\n'
      '• Schiena inarcata — corpo DRITTO come una tavola\n'
      '• Tentare la versione completa subito — progressione: tuck → advanced tuck → straddle → full\n'
      '• Trascurare i dorsali — sono il motore primario del front lever, non il core\n\n'
      'RESPIRAZIONE: Respira normalmente mantenendo la posizione.\n\n'
      'VARIANTE FACILITATA: Tuck front lever (ginocchia al petto).'),

  // -- Turkish Get-Up --
  // Bodyweight (Half Get-Up)
  ExercisesCompanion.insert(
    name: 'Half Turkish Get-Up',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(3),
    musclesPrimary: const Value('Core, Deltoidi, Glutei'),
    musclesSecondary: const Value('Obliqui, Flessori anca, Quadricipiti'),
    executionCues: const Value(
      'Da supino, braccio disteso verso il soffitto. Rotola sul gomito, poi sulla mano. Siediti. Torna giù controllato.'),
    instructions: const Value(
      'Half Turkish Get-Up — versione a corpo libero che copre la prima metà del movimento completo.\n\n'
      'PERCHÉ: Costruisce stabilità di spalla, mobilità toracica e coordinazione core in un unico movimento. '
      'La progressione dalla posizione supina alla seduta richiede il controllo di ogni segmento della catena cinetica.\n\n'
      'ERRORI COMUNI:\n'
      '• Braccio che cade in avanti — lo sguardo resta sempre sul pugno, spalla "impacchettata" nella cavità\n'
      '• Saltare i passaggi — ogni fase è separata: rotolo sul gomito → estensione sulla mano → seduta. Pausa 1s tra ogni fase\n'
      '• Gomito di appoggio che crolla — spingi attivamente il gomito nel pavimento\n'
      '• Gamba distesa che si solleva — il tallone opposto resta a contatto col suolo\n\n'
      'RESPIRAZIONE: Inspira nella posizione di partenza, espira durante ogni transizione. '
      'Respira normalmente nelle pause tra le fasi.\n\n'
      'VARIANTE FACILITATA: Pratica ogni fase separatamente (rotolo, sit-up parziale) prima di concatenare.'),
    equipment: const Value(Equipment.bodyweight),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(3),
    defaultRepsMax: const Value(5),
    defaultTempoEcc: const Value(3),
    defaultTempoCon: const Value(3),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),
  // Home (KB/DB)
  ExercisesCompanion.insert(
    name: 'Turkish Get-Up',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(4),
    musclesPrimary: const Value('Core, Deltoidi, Glutei'),
    musclesSecondary: const Value('Obliqui, Quadricipiti, Flessori anca, Trapezio'),
    executionCues: const Value(
      'Da supino, KB/DB braccio disteso. Rotola → gomito → mano → ponte → ginocchio a terra → in piedi. Inverti per tornare giù.'),
    instructions: const Value(
      'Turkish Get-Up completo con kettlebell o manubrio — l\'esercizio funzionale per eccellenza.\n\n'
      'PERCHÉ: Integra stabilità di spalla sotto carico, mobilità toracica, forza del core anti-rotazione e anti-flessione, '
      'e coordinazione di tutto il corpo in un unico movimento. Nessun altro esercizio allena tanti pattern contemporaneamente.\n\n'
      'ERRORI COMUNI:\n'
      '• Perdere il lockout del braccio — il gomito resta BLOCCATO per tutta la durata. Se cede, il peso è troppo\n'
      '• Saltare il ponte dell\'anca — fase critica per portare la gamba sotto il corpo\n'
      '• Ginocchio posteriore non allineato — deve essere sotto l\'anca nella posizione di affondo\n'
      '• Fretta — ogni rep dovrebbe durare 30-45 secondi. È un esercizio di qualità, non di velocità\n'
      '• Iniziare con un peso troppo pesante — padroneggia prima l\'Half Get-Up a corpo libero\n\n'
      'RESPIRAZIONE: Inspira nelle posizioni statiche (pause), espira durante ogni transizione.\n\n'
      'VARIANTE FACILITATA: Half Turkish Get-Up (fermarsi alla posizione seduta).'),
    equipment: const Value(Equipment.home),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(2),
    defaultRepsMax: const Value(4),
    defaultTempoEcc: const Value(3),
    defaultTempoCon: const Value(3),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),
  // Gym (barbell/KB/DB)
  ExercisesCompanion.insert(
    name: 'Turkish Get-Up con Bilanciere',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(5),
    musclesPrimary: const Value('Core, Deltoidi, Glutei'),
    musclesSecondary: const Value('Obliqui, Quadricipiti, Flessori anca, Trapezio, Avambracci'),
    executionCues: const Value(
      'Da supino, bilanciere impugnato a una mano braccio disteso. Stessa sequenza del TGU con KB ma con maggiore richiesta di stabilità.'),
    instructions: const Value(
      'Turkish Get-Up con bilanciere — variante avanzata che richiede stabilità di polso e spalla superiore.\n\n'
      'PERCHÉ: Il bilanciere ha una leva più lunga e un centro di gravità distribuito diversamente, '
      'costringendo gli stabilizzatori della spalla e del polso a lavorare molto più intensamente.\n\n'
      'ERRORI COMUNI:\n'
      '• Polso che cede lateralmente — impugnatura salda, polso perfettamente neutro\n'
      '• Bilanciere che oscilla — movimenti ancora più lenti e controllati rispetto alla versione KB\n'
      '• Tentare senza padronanza del TGU con KB — prerequisito: 5 TGU puliti con KB pesante\n\n'
      'RESPIRAZIONE: Inspira nelle posizioni statiche, espira durante ogni transizione.\n\n'
      'VARIANTE FACILITATA: Turkish Get-Up con KB o manubrio.'),
    equipment: const Value(Equipment.gym),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(1),
    defaultRepsMax: const Value(3),
    defaultTempoEcc: const Value(3),
    defaultTempoCon: const Value(3),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),

  // -- Farmer Walk (loaded carry bilaterale) --
  // Home (KB/DB)
  ExercisesCompanion.insert(
    name: 'Farmer Walk',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(2),
    musclesPrimary: const Value('Avambracci, Trapezio, Core'),
    musclesSecondary: const Value('Glutei, Quadricipiti, Erettori spinali'),
    executionCues: const Value(
      'Due KB o manubri ai fianchi. Schiena dritta, spalle depresse. Cammina a passi corti e controllati. Petto alto.'),
    instructions: const Value(
      'Farmer Walk — camminata caricata bilaterale. Il fondamentale dei loaded carry.\n\n'
      'PERCHÉ: Allena la forza di presa, la stabilità del core sotto carico dinamico e la resistenza di trapezio ed erettori spinali. '
      'Uno dei movimenti più funzionali e trasferibili alla vita quotidiana (McGill, 2015).\n\n'
      'ERRORI COMUNI:\n'
      '• Spalle che salgono alle orecchie — deprimi le scapole e mantieni il collo lungo\n'
      '• Passi troppo lunghi — passi corti e rapidi mantengono la stabilità\n'
      '• Pendolarismo laterale — il tronco deve restare rigido, senza oscillazioni\n'
      '• Schiena arrotondata — petto alto, sguardo avanti, core contratto\n\n'
      'RESPIRAZIONE: Respira con pattern naturale. Inspira per 2-3 passi, espira per 2-3 passi. '
      'Non trattenere il fiato.\n\n'
      'VARIANTE FACILITATA: Farmer walk con pesi leggeri su distanza breve (10m).'),
    equipment: const Value(Equipment.home),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(30),
    defaultRepsMax: const Value(45),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),
  // Gym (trap bar / heavy DB)
  ExercisesCompanion.insert(
    name: 'Farmer Walk Pesante',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(3),
    musclesPrimary: const Value('Avambracci, Trapezio, Core'),
    musclesSecondary: const Value('Glutei, Quadricipiti, Erettori spinali'),
    executionCues: const Value(
      'Manubri pesanti o trap bar caricata. Schiena dritta, spalle depresse. Cammina 20-30m. Petto alto, core rigido.'),
    instructions: const Value(
      'Farmer Walk pesante — versione con carichi significativi (0.75-1.0× peso corporeo per mano).\n\n'
      'PERCHÉ: Carichi elevati costruiscono forza di presa funzionale, resistenza del core sotto carico pesante '
      'e densità ossea per via dello stress compressivo assiale.\n\n'
      'ERRORI COMUNI:\n'
      '• Presa che cede prima del core — usa gesso o cinghie solo se la presa è il fattore limitante e vuoi allenare il core\n'
      '• Velocità troppo alta — cammina con controllo, non correre\n'
      '• Perdere la postura sotto carico — se la schiena cede, il peso è troppo\n\n'
      'RESPIRAZIONE: Respira ritmicamente con i passi. Evita apnea prolungata.\n\n'
      'VARIANTE FACILITATA: Farmer Walk con KB/DB leggeri.'),
    equipment: const Value(Equipment.gym),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(30),
    defaultRepsMax: const Value(45),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),

  // -- Suitcase Carry (anti-lateral flexion) --
  // Home (KB/DB)
  ExercisesCompanion.insert(
    name: 'Suitcase Carry',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(3),
    musclesPrimary: const Value('Obliqui, Quadrato dei lombi, Core'),
    musclesSecondary: const Value('Avambracci, Trapezio, Gluteo medio'),
    executionCues: const Value(
      'Un solo KB o manubrio in una mano. Cammina DRITTO senza inclinarti verso il peso. Spalle livellate. Alterna lato.'),
    instructions: const Value(
      'Suitcase Carry — loaded carry unilaterale. Il miglior esercizio anti-flessione laterale.\n\n'
      'PERCHÉ: Il carico asimmetrico forza gli obliqui e il quadrato dei lombi a lavorare per impedire '
      'l\'inclinazione laterale del tronco. Questo pattern anti-flessione laterale è critico per la salute della colonna '
      'e raramente allenato dagli esercizi tradizionali (McGill, 2015).\n\n'
      'ERRORI COMUNI:\n'
      '• Inclinarsi verso il peso — il punto è RESISTERE all\'inclinazione. Le spalle devono restare perfettamente livellate\n'
      '• Compensare con l\'anca — non spingere l\'anca verso il lato opposto\n'
      '• Braccio libero che si agita — tienilo lungo il fianco o con pugno chiuso\n'
      '• Dimenticare di alternare — esegui lo stesso tempo/distanza per entrambi i lati\n\n'
      'RESPIRAZIONE: Respira naturalmente. L\'espirazione aiuta ad attivare maggiormente gli obliqui.\n\n'
      'VARIANTE FACILITATA: Suitcase hold statico (in piedi, senza camminare) per 20-30s per lato.'),
    equipment: const Value(Equipment.home),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(30),
    defaultRepsMax: const Value(45),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),
  // Gym
  ExercisesCompanion.insert(
    name: 'Suitcase Carry Pesante',
    category: ExerciseCategory.core,
    phoenixLevel: const Value(4),
    musclesPrimary: const Value('Obliqui, Quadrato dei lombi, Core'),
    musclesSecondary: const Value('Avambracci, Trapezio, Gluteo medio'),
    executionCues: const Value(
      'Un manubrio pesante in una mano. Cammina 20-30m DRITTO. Spalle livellate. Alterna lato.'),
    instructions: const Value(
      'Suitcase Carry pesante — versione con carico significativo (0.5× peso corporeo).\n\n'
      'PERCHÉ: Carichi elevati massimizzano la richiesta anti-flessione laterale su obliqui e quadrato dei lombi.\n\n'
      'ERRORI COMUNI:\n'
      '• Perdere l\'allineamento — se ti inclini, il peso è troppo\n'
      '• Presa che cede — la presa è spesso il fattore limitante. Alternativa: fat grip per allenare anche la presa\n\n'
      'RESPIRAZIONE: Respira ritmicamente con i passi.\n\n'
      'VARIANTE FACILITATA: Suitcase Carry con KB/DB leggero.'),
    equipment: const Value(Equipment.gym),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(30),
    defaultRepsMax: const Value(45),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.compound),
  ),

  // -- Overhead Carry (shoulder stability) --
  // Home (KB/DB)
  ExercisesCompanion.insert(
    name: 'Overhead Carry',
    category: ExerciseCategory.push,
    phoenixLevel: const Value(4),
    musclesPrimary: const Value('Deltoidi, Trapezio, Core'),
    musclesSecondary: const Value('Tricipiti, Erettori spinali, Obliqui'),
    executionCues: const Value(
      'Un KB o manubrio sopra la testa, braccio bloccato. Cammina a passi corti. Costole basse, core rigido. Alterna lato.'),
    instructions: const Value(
      'Overhead Carry — loaded carry con peso sopra la testa. Costruisce stabilità di spalla sotto carico dinamico.\n\n'
      'PERCHÉ: La posizione overhead sotto carico durante la deambulazione è la sfida definitiva per gli stabilizzatori della spalla '
      '(cuffia dei rotatori, trapezio inferiore, dentato anteriore). Allena anche il core anti-estensione '
      'perché il carico sopra la testa tende a iperestendere la lombare.\n\n'
      'ERRORI COMUNI:\n'
      '• Costole che si aprono / schiena inarcata — "costole basse", stringi gli addominali come per un pugno allo stomaco\n'
      '• Gomito piegato — il braccio deve essere COMPLETAMENTE disteso, bicipite vicino all\'orecchio\n'
      '• Spalla che sale — deprimi la scapola, "spingi il peso verso il soffitto"\n'
      '• Compensazione laterale — non inclinarti dal lato opposto al peso\n\n'
      'RESPIRAZIONE: Respira normalmente. Espira con leggera contrazione addominale per mantenere le costole basse.\n\n'
      'VARIANTE FACILITATA: Overhead hold statico (in piedi, senza camminare) per 20-30s per lato.'),
    equipment: const Value(Equipment.home),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(20),
    defaultRepsMax: const Value(30),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.push),
    exerciseType: const Value(ExerciseType.compound),
  ),
  // Gym
  ExercisesCompanion.insert(
    name: 'Overhead Carry Pesante',
    category: ExerciseCategory.push,
    phoenixLevel: const Value(5),
    musclesPrimary: const Value('Deltoidi, Trapezio, Core'),
    musclesSecondary: const Value('Tricipiti, Erettori spinali, Obliqui'),
    executionCues: const Value(
      'KB o manubrio pesante sopra la testa, braccio bloccato. Cammina 15-20m. Costole basse. Alterna lato.'),
    instructions: const Value(
      'Overhead Carry pesante — versione con carico significativo per avanzati.\n\n'
      'PERCHÉ: Massimizza la richiesta sugli stabilizzatori di spalla e core anti-estensione sotto carico pesante.\n\n'
      'ERRORI COMUNI:\n'
      '• Perdere il lockout — se il gomito cede, il peso è troppo\n'
      '• Lombare che iperestende — "costole basse" è il cue fondamentale\n'
      '• Velocità eccessiva — passi corti e controllati\n\n'
      'RESPIRAZIONE: Respira ritmicamente. Espira attivamente per mantenere la posizione.\n\n'
      'VARIANTE FACILITATA: Overhead Carry con KB/DB leggero.'),
    equipment: const Value(Equipment.gym),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(20),
    defaultRepsMax: const Value(30),
    defaultTempoEcc: const Value(0),
    defaultTempoCon: const Value(0),
    dayType: const Value(ExerciseCategory.push),
    exerciseType: const Value(ExerciseType.compound),
  ),
];

// ─── Helper constructors ─────────────────────────────────────────

ExercisesCompanion _push(String name, int level, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.push,
    phoenixLevel: Value(level),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.push),
    exerciseType: Value(ExerciseType.compound),
  );
}

ExercisesCompanion _pushAccessory(String name, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.push,
    phoenixLevel: const Value(1),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.push),
    exerciseType: Value(ExerciseType.accessory),
  );
}

ExercisesCompanion _pull(String name, int level, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.pull,
    phoenixLevel: Value(level),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.pull),
    exerciseType: Value(ExerciseType.compound),
  );
}

ExercisesCompanion _pullAccessory(String name, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.pull,
    phoenixLevel: const Value(1),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.pull),
    exerciseType: Value(ExerciseType.accessory),
  );
}

ExercisesCompanion _squat(String name, int level, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.squat,
    phoenixLevel: Value(level),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.squat),
    exerciseType: Value(ExerciseType.compound),
  );
}

ExercisesCompanion _squatAccessory(String name, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.squat,
    phoenixLevel: const Value(1),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.squat),
    exerciseType: Value(ExerciseType.accessory),
  );
}

ExercisesCompanion _hinge(String name, int level, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.hinge,
    phoenixLevel: Value(level),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.hinge),
    exerciseType: Value(ExerciseType.compound),
  );
}

ExercisesCompanion _hingeAccessory(String name, String equip,
    String primary, String secondary, String cues, String instructions,
    int sets, int repsMin, int repsMax) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.hinge,
    phoenixLevel: const Value(1),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: Value(equip),
    defaultSets: Value(sets),
    defaultRepsMin: Value(repsMin),
    defaultRepsMax: Value(repsMax),
    dayType: Value(ExerciseCategory.hinge),
    exerciseType: Value(ExerciseType.accessory),
  );
}

ExercisesCompanion _core(String name, int level, String primary,
    String secondary, String cues, String instructions) {
  return ExercisesCompanion.insert(
    name: name,
    category: ExerciseCategory.core,
    phoenixLevel: Value(level),
    musclesPrimary: Value(primary),
    musclesSecondary: Value(secondary),
    executionCues: Value(cues),
    instructions: Value(instructions),
    equipment: const Value(Equipment.all),
    defaultSets: const Value(3),
    defaultRepsMin: const Value(8),
    defaultRepsMax: const Value(15),
    dayType: const Value(ExerciseCategory.core),
    exerciseType: const Value(ExerciseType.core),
  );
}
