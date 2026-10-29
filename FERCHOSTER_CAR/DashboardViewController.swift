import UIKit
import AVFoundation
import MediaPlayer

final class DashboardViewController: UIViewController {
    private let navy = UIColor(red: 12/255, green: 20/255, blue: 34/255, alpha: 1)
    private let panel = UIColor(red: 25/255, green: 36/255, blue: 53/255, alpha: 1)
    private let blue = UIColor(red: 43/255, green: 139/255, blue: 230/255, alpha: 1)
    private let silver = UIColor(red: 192/255, green: 205/255, blue: 220/255, alpha: 1)
    private let main = UIView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusLabel = UILabel()
    private let sectionLabel = UILabel()
    private var timer: Timer?
    private var selectedSection = "INICIO"

    override var prefersStatusBarHidden: Bool { return true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscape }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = navy
        buildUI()
        updateClock()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    deinit { timer?.invalidate() }

    private func buildUI() {
        let header = UIView()
        header.backgroundColor = UIColor(red: 8/255, green: 14/255, blue: 25/255, alpha: 1)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        titleLabel.text = "FERCHOSTER CAR"
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)

        let owner = UILabel()
        owner.text = "Fher Nando Batres"
        owner.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        owner.textColor = silver
        owner.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(owner)

        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        timeLabel.textColor = blue
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(timeLabel)

        let sidebar = UIStackView()
        sidebar.axis = .vertical
        sidebar.spacing = 7
        sidebar.distribution = .fillEqually
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sidebar)

        let items = [("⌂", "INICIO"), ("♫", "MÚSICA"), ("◉", "RADIO"), ("❄", "CLIMA"), ("▶", "VIDEOS"), ("⌖", "MAPAS"), ("▦", "APPS"), ("⚙", "AJUSTES")]
        for (symbol, name) in items {
            let button = UIButton(type: .system)
            button.backgroundColor = name == selectedSection ? blue : panel
            button.layer.cornerRadius = 10
            button.setTitle("\(symbol)  \(name)", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 3)
            button.tag = items.firstIndex(where: {$0.1 == name}) ?? 0
            button.addTarget(self, action: #selector(sectionTapped(_:)), for: .touchUpInside)
            sidebar.addArrangedSubview(button)
        }

        main.backgroundColor = panel
        main.layer.cornerRadius = 18
        main.layer.borderWidth = 1
        main.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main)

        sectionLabel.text = "BIENVENIDO, FHER"
        sectionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        sectionLabel.textColor = .white
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        main.addSubview(sectionLabel)

        let subtitle = UILabel()
        subtitle.text = "Tu experiencia multimedia, en un solo lugar"
        subtitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitle.textColor = silver
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        main.addSubview(subtitle)

        let carCard = makeCard(title: "VEHÍCULO", detail: "Hyundai Santa Fe Sport · 2017", symbol: "🚘")
        main.addSubview(carCard)
        let mediaCard = makeCard(title: "MULTIMEDIA", detail: "Selecciona Música para comenzar", symbol: "♫")
        main.addSubview(mediaCard)

        statusLabel.text = "INTERFAZ DEMOSTRATIVA · DATOS DEL VEHÍCULO NO CONECTADOS"
        statusLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        statusLabel.textColor = silver.withAlphaComponent(0.8)
        statusLabel.numberOfLines = 1
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 58),

            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            owner.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            owner.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -22),
            timeLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),

            sidebar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sidebar.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            sidebar.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -8),
            sidebar.widthAnchor.constraint(equalToConstant: 142),

            main.leadingAnchor.constraint(equalTo: sidebar.trailingAnchor, constant: 12),
            main.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            main.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            main.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -8),

            sectionLabel.leadingAnchor.constraint(equalTo: main.leadingAnchor, constant: 22),
            sectionLabel.topAnchor.constraint(equalTo: main.topAnchor, constant: 22),
            subtitle.leadingAnchor.constraint(equalTo: sectionLabel.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 6),

            carCard.leadingAnchor.constraint(equalTo: main.leadingAnchor, constant: 22),
            carCard.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 18),
            carCard.widthAnchor.constraint(equalTo: main.widthAnchor, multiplier: 0.46),
            carCard.bottomAnchor.constraint(equalTo: main.bottomAnchor, constant: -18),

            mediaCard.leadingAnchor.constraint(equalTo: carCard.trailingAnchor, constant: 12),
            mediaCard.trailingAnchor.constraint(equalTo: main.trailingAnchor, constant: -18),
            mediaCard.topAnchor.constraint(equalTo: carCard.topAnchor),
            mediaCard.bottomAnchor.constraint(equalTo: carCard.bottomAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: main.leadingAnchor, constant: 4),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
    }

    private func makeCard(title: String, detail: String, symbol: String) -> UIView {
        let card = UIView()
        card.backgroundColor = navy.withAlphaComponent(0.65)
        card.layer.cornerRadius = 14
        card.layer.borderWidth = 1
        card.layer.borderColor = blue.withAlphaComponent(0.3).cgColor
        let icon = UILabel()
        icon.text = symbol
        icon.font = UIFont.systemFont(ofSize: 30)
        icon.textColor = blue
        icon.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(icon)
        let heading = UILabel()
        heading.text = title
        heading.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        heading.textColor = blue
        heading.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(heading)
        let text = UILabel()
        text.text = detail
        text.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        text.textColor = .white
        text.numberOfLines = 2
        text.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(text)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            heading.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
            heading.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            text.leadingAnchor.constraint(equalTo: heading.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            text.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 7),
            text.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -12)
        ])
        return card
    }

    @objc private func updateClock() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_GT")
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: Date())
    }

    @objc private func sectionTapped(_ sender: UIButton) {
        let items = ["INICIO", "MÚSICA", "RADIO", "CLIMA", "VIDEOS", "MAPAS", "APPS", "AJUSTES"]
        selectedSection = items[sender.tag]
        for case let button as UIButton in (sender.superview?.arrangedSubviews ?? []) {
            button.backgroundColor = button.tag == sender.tag ? blue : panel
        }
        switch selectedSection {
        case "MÚSICA":
            sectionLabel.text = "MÚSICA"
            // iOS media controls can be added in a later phase.
            presentMessage("Reproductor", "La pantalla de música está preparada para la siguiente fase de desarrollo.")
        case "RADIO":
            sectionLabel.text = "RADIO"
            presentMessage("Radio original", "El control de emisoras FM/AM requiere una interfaz compatible con el equipo Hyundai.")
        case "CLIMA":
            sectionLabel.text = "CLIMA"
            presentMessage("Climatización", "Los controles reales requieren una integración electrónica compatible.")
        case "VIDEOS":
            sectionLabel.text = "VIDEOS"
            presentMessage("Videos", "El reproductor local se implementará en la siguiente fase.")
        case "MAPAS":
            sectionLabel.text = "MAPAS"
            presentMessage("Mapas", "Puedes seguir utilizando la navegación disponible en CarPlay.")
        case "APPS":
            sectionLabel.text = "APLICACIONES"
            presentMessage("Aplicaciones", "Los accesos dependerán de la compatibilidad con iOS y CarBridge.")
        case "AJUSTES":
            sectionLabel.text = "AJUSTES"
            presentMessage("Ajustes", "FERCHOSTER CAR · Versión 1.0")
        default:
            sectionLabel.text = "BIENVENIDO, FHER"
        }
    }

    private func presentMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
