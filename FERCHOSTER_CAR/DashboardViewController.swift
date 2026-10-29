import UIKit
import AVFoundation
import MediaPlayer

final class DashboardViewController: UIViewController {
    private let navy = UIColor(red: 8/255, green: 16/255, blue: 29/255, alpha: 1)
    private let panel = UIColor(red: 17/255, green: 30/255, blue: 48/255, alpha: 1)
    private let lightPanel = UIColor(red: 27/255, green: 46/255, blue: 70/255, alpha: 1)
    private let blue = UIColor(red: 0/255, green: 151/255, blue: 255/255, alpha: 1)
    private let silver = UIColor(red: 196/255, green: 211/255, blue: 228/255, alpha: 1)
    private let root = UIView()
    private let header = UIView()
    private let sidebar = UIStackView()
    private let content = UIView()
    private let clockLabel = UILabel()
    private let dateLabel = UILabel()
    private let radioFrequency = UILabel()
    private let songTitle = UILabel()
    private let songSubtitle = UILabel()
    private let playButton = UIButton(type: .system)
    private var timer: Timer?
    private var playing = false

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
    override var shouldAutorotate: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = navy
        buildUI()
        updateClock()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    deinit { timer?.invalidate() }

    private func makeLabel(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight = .regular, _ color: UIColor = .white) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = UIFont.systemFont(ofSize: size, weight: weight)
        l.textColor = color
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.65
        return l
    }
    private func card(_ title: String? = nil) -> UIView {
        let v = UIView()
        v.backgroundColor = panel
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = blue.withAlphaComponent(0.42).cgColor
        if let title = title {
            let l = makeLabel(title, 13, .semibold, silver)
            l.translatesAutoresizingMaskIntoConstraints = false
            v.addSubview(l)
            NSLayoutConstraint.activate([
                l.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 10),
                l.topAnchor.constraint(equalTo: v.topAnchor, constant: 7)
            ])
        }
        return v
    }
    private func actionButton(_ title: String, tag: Int, target: Any, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        b.backgroundColor = lightPanel
        b.layer.cornerRadius = 8
        b.layer.borderWidth = 1
        b.layer.borderColor = blue.withAlphaComponent(0.35).cgColor
        b.tag = tag
        b.addTarget(target, action: action, for: .touchUpInside)
        return b
    }

    private func buildUI() {
        root.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(root)
        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            root.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            root.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6)
        ])

        header.backgroundColor = UIColor(red: 6/255, green: 13/255, blue: 24/255, alpha: 1)
        header.layer.cornerRadius = 12
        header.layer.borderWidth = 1
        header.layer.borderColor = blue.withAlphaComponent(0.35).cgColor
        header.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(header)

        let logo = makeLabel("HYUNDAI", 15, .heavy, silver)
        let name = makeLabel("Fher Nando Batres", 21, .bold)
        let signal = makeLabel("▮▮▮   Wi-Fi   ▰", 12, .semibold, blue)
        for v in [logo, name, signal, clockLabel, dateLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(v)
        }
        clockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        clockLabel.textColor = .white
        clockLabel.textAlignment = .right
        dateLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        dateLabel.textColor = silver
        dateLabel.textAlignment = .right

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            header.topAnchor.constraint(equalTo: root.topAnchor),
            header.heightAnchor.constraint(equalTo: root.heightAnchor, multiplier: 0.12),
            logo.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            logo.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 15),
            name.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            name.trailingAnchor.constraint(lessThanOrEqualTo: signal.leadingAnchor, constant: -8),
            signal.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            signal.trailingAnchor.constraint(equalTo: clockLabel.leadingAnchor, constant: -12),
            clockLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -12),
            clockLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: clockLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: clockLabel.bottomAnchor, constant: 0)
        ])

        sidebar.axis = .vertical
        sidebar.spacing = 4
        sidebar.distribution = .fillEqually
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(sidebar)
        let items = ["⌂  Inicio", "♫  Música", "▤  Radio", "❄  Clima", "☎  Teléfono", "➤  Mapas", "▶  Videos", "▦  Apps", "▰  Vehículo", "⚙  Ajustes"]
        for (i, item) in items.enumerated() {
            let b = actionButton(item, tag: i, target: self, action: #selector(menuTapped(_:)))
            b.contentHorizontalAlignment = .left
            b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 1)
            if i == 0 { b.backgroundColor = blue }
            sidebar.addArrangedSubview(b)
        }

        content.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(content)

        let hero = card()
        hero.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(hero)
        let welcome = makeLabel("BIENVENIDO, FHER", 17, .bold)
        let weather = makeLabel("☀  24°C   Palín, Escuintla", 12, .medium, silver)
        let car = makeLabel("HYUNDAI\nSANTA FE SPORT", 24, .bold, silver)
        car.numberOfLines = 2
        car.textAlignment = .center
        car.backgroundColor = UIColor(red: 10/255, green: 25/255, blue: 43/255, alpha: 1)
        car.layer.cornerRadius = 10
        car.clipsToBounds = true
        for v in [welcome, weather, car] {
            v.translatesAutoresizingMaskIntoConstraints = false
            hero.addSubview(v)
        }
        NSLayoutConstraint.activate([
            welcome.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 12),
            welcome.topAnchor.constraint(equalTo: hero.topAnchor, constant: 10),
            weather.leadingAnchor.constraint(equalTo: welcome.leadingAnchor),
            weather.topAnchor.constraint(equalTo: welcome.bottomAnchor, constant: 4),
            car.leadingAnchor.constraint(equalTo: hero.leadingAnchor, constant: 9),
            car.trailingAnchor.constraint(equalTo: hero.trailingAnchor, constant: -9),
            car.topAnchor.constraint(equalTo: weather.bottomAnchor, constant: 8),
            car.bottomAnchor.constraint(equalTo: hero.bottomAnchor, constant: -9)
        ])

        let climate = card("❄  Climatización")
        climate.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(climate)
        let temp = makeLabel("−    22°C    +", 17, .bold)
        temp.textAlignment = .center
        temp.backgroundColor = lightPanel
        temp.layer.cornerRadius = 8
        temp.clipsToBounds = true
        let fan = makeLabel("VENTILADOR   ▮ ▮ ▮ ▯", 10, .medium, silver)
        let ac = actionButton("A/C   ⟳   SYNC", tag: 0, target: self, action: #selector(climateTapped))
        for v in [temp, fan, ac] {
            v.translatesAutoresizingMaskIntoConstraints = false
            climate.addSubview(v)
        }
        NSLayoutConstraint.activate([
            temp.leadingAnchor.constraint(equalTo: climate.leadingAnchor, constant: 8),
            temp.bottomAnchor.constraint(equalTo: climate.bottomAnchor, constant: -8),
            temp.widthAnchor.constraint(equalTo: climate.widthAnchor, multiplier: 0.38),
            temp.heightAnchor.constraint(equalTo: climate.heightAnchor, multiplier: 0.42),
            fan.leadingAnchor.constraint(equalTo: temp.trailingAnchor, constant: 5),
            fan.centerYAnchor.constraint(equalTo: temp.centerYAnchor),
            fan.trailingAnchor.constraint(equalTo: ac.leadingAnchor, constant: -4),
            ac.trailingAnchor.constraint(equalTo: climate.trailingAnchor, constant: -7),
            ac.centerYAnchor.constraint(equalTo: temp.centerYAnchor),
            ac.widthAnchor.constraint(equalTo: climate.widthAnchor, multiplier: 0.24),
            ac.heightAnchor.constraint(equalTo: temp.heightAnchor)
        ])

        let music = card("♫  Música")
        music.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(music)
        let album = makeLabel("FH\nCAR", 18, .heavy, blue)
        album.numberOfLines = 2
        album.textAlignment = .center
        album.backgroundColor = UIColor(red: 3/255, green: 48/255, blue: 87/255, alpha: 1)
        album.layer.cornerRadius = 9
        album.clipsToBounds = true
        songTitle.text = "Reproductor multimedia"
        songTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        songTitle.textColor = .white
        songTitle.numberOfLines = 2
        songSubtitle.text = "Conecta una fuente de audio"
        songSubtitle.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        songSubtitle.textColor = silver
        songSubtitle.numberOfLines = 2
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progress = 0.28
        progress.progressTintColor = blue
        progress.trackTintColor = lightPanel
        playButton.setTitle("▶", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        playButton.backgroundColor = blue.withAlphaComponent(0.25)
        playButton.layer.cornerRadius = 20
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor = blue.cgColor
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        for v in [album, songTitle, songSubtitle, progress, playButton] {
            v.translatesAutoresizingMaskIntoConstraints = false
            music.addSubview(v)
        }
        NSLayoutConstraint.activate([
            album.leadingAnchor.constraint(equalTo: music.leadingAnchor, constant: 10),
            album.topAnchor.constraint(equalTo: music.topAnchor, constant: 32),
            album.widthAnchor.constraint(equalTo: music.widthAnchor, multiplier: 0.28),
            album.heightAnchor.constraint(equalTo: album.widthAnchor),
            songTitle.leadingAnchor.constraint(equalTo: album.trailingAnchor, constant: 9),
            songTitle.trailingAnchor.constraint(equalTo: music.trailingAnchor, constant: -8),
            songTitle.topAnchor.constraint(equalTo: album.topAnchor, constant: 1),
            songSubtitle.leadingAnchor.constraint(equalTo: songTitle.leadingAnchor),
            songSubtitle.trailingAnchor.constraint(equalTo: songTitle.trailingAnchor),
            songSubtitle.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 3),
            progress.leadingAnchor.constraint(equalTo: songTitle.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: songTitle.trailingAnchor),
            progress.topAnchor.constraint(equalTo: songSubtitle.bottomAnchor, constant: 4),
            playButton.centerXAnchor.constraint(equalTo: music.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: music.bottomAnchor, constant: -5),
            playButton.widthAnchor.constraint(equalToConstant: 38),
            playButton.heightAnchor.constraint(equalToConstant: 38)
        ])

        let radio = card("▤  Radio FM")
        radio.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(radio)
        radioFrequency.text = "102.5 MHz"
        radioFrequency.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        radioFrequency.textColor = .white
        radioFrequency.textAlignment = .center
        radioFrequency.translatesAutoresizingMaskIntoConstraints = false
        radio.addSubview(radioFrequency)
        let stations = UIStackView()
        stations.axis = .horizontal
        stations.spacing = 4
        stations.distribution = .fillEqually
        stations.translatesAutoresizingMaskIntoConstraints = false
        radio.addSubview(stations)
        for station in ["87.9", "91.3", "94.1", "102.5", "106.9"] {
            stations.addArrangedSubview(actionButton(station, tag: 0, target: self, action: #selector(stationTapped(_:))))
        }
        NSLayoutConstraint.activate([
            radioFrequency.centerXAnchor.constraint(equalTo: radio.centerXAnchor),
            radioFrequency.topAnchor.constraint(equalTo: radio.topAnchor, constant: 25),
            stations.leadingAnchor.constraint(equalTo: radio.leadingAnchor, constant: 7),
            stations.trailingAnchor.constraint(equalTo: radio.trailingAnchor, constant: -7),
            stations.bottomAnchor.constraint(equalTo: radio.bottomAnchor, constant: -6),
            stations.heightAnchor.constraint(equalToConstant: 25)
        ])

        let apps = card("Aplicaciones")
        apps.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(apps)
        let appStack = UIStackView()
        appStack.axis = .horizontal
        appStack.spacing = 5
        appStack.distribution = .fillEqually
        appStack.translatesAutoresizingMaskIntoConstraints = false
        apps.addSubview(appStack)
        for app in ["▶\nVideos", "♫\nMúsica", "➤\nMapas", "▦\nApps"] {
            let b = actionButton(app, tag: 0, target: self, action: #selector(appTapped(_:)))
            b.titleLabel?.numberOfLines = 2
            appStack.addArrangedSubview(b)
        }
        NSLayoutConstraint.activate([
            appStack.leadingAnchor.constraint(equalTo: apps.leadingAnchor, constant: 7),
            appStack.trailingAnchor.constraint(equalTo: apps.trailingAnchor, constant: -7),
            appStack.topAnchor.constraint(equalTo: apps.topAnchor, constant: 28),
            appStack.bottomAnchor.constraint(equalTo: apps.bottomAnchor, constant: -6)
        ])

        let bottom = UIStackView()
        bottom.axis = .horizontal
        bottom.spacing = 4
        bottom.distribution = .fillEqually
        bottom.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(bottom)
        for title in ["CarPlay", "Teléfono", "Cámara", "Vehículo", "Pantalla"] {
            bottom.addArrangedSubview(actionButton(title, tag: 0, target: self, action: #selector(appTapped(_:))))
        }

        NSLayoutConstraint.activate([
            sidebar.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            sidebar.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 7),
            sidebar.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -15),
            sidebar.widthAnchor.constraint(equalTo: root.widthAnchor, multiplier: 0.14),

            content.leadingAnchor.constraint(equalTo: sidebar.trailingAnchor, constant: 7),
            content.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            content.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 7),
            content.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -15),

            hero.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            hero.topAnchor.constraint(equalTo: content.topAnchor),
            hero.widthAnchor.constraint(equalTo: content.widthAnchor, multiplier: 0.53),
            hero.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.64),

            climate.leadingAnchor.constraint(equalTo: hero.leadingAnchor),
            climate.trailingAnchor.constraint(equalTo: hero.trailingAnchor),
            climate.topAnchor.constraint(equalTo: hero.bottomAnchor, constant: 6),
            climate.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),

            music.leadingAnchor.constraint(equalTo: hero.trailingAnchor, constant: 6),
            music.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            music.topAnchor.constraint(equalTo: content.topAnchor),
            music.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.36),

            radio.leadingAnchor.constraint(equalTo: music.leadingAnchor),
            radio.trailingAnchor.constraint(equalTo: music.trailingAnchor),
            radio.topAnchor.constraint(equalTo: music.bottomAnchor, constant: 6),
            radio.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.22),

            apps.leadingAnchor.constraint(equalTo: radio.leadingAnchor),
            apps.trailingAnchor.constraint(equalTo: radio.trailingAnchor),
            apps.topAnchor.constraint(equalTo: radio.bottomAnchor, constant: 6),
            apps.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),

            bottom.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            bottom.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            bottom.heightAnchor.constraint(equalToConstant: 19)
        ])
    }

    @objc private func updateClock() {
        let t = DateFormatter()
        t.locale = Locale(identifier: "es_GT")
        t.dateFormat = "h:mm a"
        clockLabel.text = t.string(from: Date())
        let d = DateFormatter()
        d.locale = Locale(identifier: "es_GT")
        d.dateFormat = "EEEE d MMM yyyy"
        dateLabel.text = d.string(from: Date()).capitalized
    }
    @objc private func menuTapped(_ sender: UIButton) {
        let sections = ["INICIO", "MÚSICA", "RADIO", "CLIMA", "TELÉFONO", "MAPAS", "VIDEOS", "APPS", "VEHÍCULO", "AJUSTES"]
        for case let b as UIButton in sidebar.arrangedSubviews {
            b.backgroundColor = b.tag == sender.tag ? blue : panel
        }
        let section = sections[min(sender.tag, sections.count - 1)]
        switch section {
        case "RADIO":
            message("Radio FM", "La frecuencia mostrada es visual. Cambiar la emisora real requiere una integración compatible con el radio Hyundai.")
        case "CLIMA":
            message("Climatización", "Los controles son demostrativos; no modifican el aire acondicionado real sin una interfaz electrónica compatible.")
        case "VEHÍCULO":
            message("Vehículo", "Los datos de combustible, batería y kilometraje no están conectados al vehículo.")
        case "VIDEOS":
            message("Videos", "La reproducción depende de una fuente compatible y de las restricciones de iOS/CarPlay. No reproduzcas videos mientras conduces.")
        case "TELÉFONO":
            message("Teléfono", "Utiliza las funciones de llamadas disponibles mediante CarPlay.")
        case "MAPAS":
            message("Mapas", "Puedes usar la navegación disponible en CarPlay.")
        case "APPS":
            message("Aplicaciones", "Los accesos dependen de las aplicaciones instaladas y de su compatibilidad.")
        case "AJUSTES":
            message("FERCHOSTER CAR", "Interfaz personalizada para Fher Nando Batres.")
        case "MÚSICA":
            songTitle.text = "Audio del iPhone"
            songSubtitle.text = "Controles reales aún por integrar"
        default: break
        }
    }
    @objc private func playTapped() {
        playing.toggle()
        playButton.setTitle(playing ? "Ⅱ" : "▶", for: .normal)
        songSubtitle.text = playing ? "Estado visual: reproduciendo" : "Reproducción pausada"
    }
    @objc private func stationTapped(_ sender: UIButton) {
        radioFrequency.text = "\(sender.title(for: .normal) ?? "102.5") MHz"
    }
    @objc private func climateTapped() {
        message("Climatización", "Estos controles son visuales y no controlan el aire real del vehículo.")
    }
    @objc private func appTapped(_ sender: UIButton) {
        message(sender.title(for: .normal) ?? "Acceso", "Este acceso es visual. La función real requiere integrar una aplicación o servicio compatible.")
    }
    private func message(_ title: String, _ text: String) {
        let a = UIAlertController(title: title, message: text, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(a, animated: true)
    }
}

