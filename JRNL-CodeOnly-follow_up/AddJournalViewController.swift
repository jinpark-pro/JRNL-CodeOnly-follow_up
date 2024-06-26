//
//  AddJournalViewController.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-18.
//

import UIKit
import CoreLocation

protocol AddJournalControllerDelegate: NSObject {
    func saveJournalEntry(_ journalEntry: JournalEntry)
}

class AddJournalViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: AddJournalControllerDelegate?
    
    final let LABEL_VIEW_TAG = 1001
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let switchComponent = UISwitch()
    let labelToggleComponent = UILabel()
    
    var locationSwitchIsOn = false {
        didSet {
            updateSaveButtonState()
        }
    }
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var ratingView: RatingView = {
        let ratingView = RatingView(frame: CGRect(x: 0, y: 0, width: 252, height: 44))
        ratingView.distribution = .fillEqually
        return ratingView
    }()
    
    private lazy var toggleView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        switchComponent.isOn = false
        switchComponent.addAction(UIAction { [weak self] _ in
            if let isOn = self?.switchComponent.isOn, isOn {
                self?.locationSwitchIsOn = true
                if let label = self?.toggleView.viewWithTag(self?.LABEL_VIEW_TAG ?? 1001) as? UILabel {
                    label.text = "Getting Location..."
                }
                self?.locationManager.requestLocation()
            } else {
                self?.locationSwitchIsOn = false
                self?.currentLocation = nil
                if let label = self?.toggleView.viewWithTag(self?.LABEL_VIEW_TAG ?? 1001) as? UILabel {
                    label.text = "Get Location"
                }
            }
        }, for: .valueChanged)
        
        
        labelToggleComponent.text = "Get Location"
        labelToggleComponent.tag = LABEL_VIEW_TAG
        stackView.addArrangedSubview(switchComponent)
        stackView.addArrangedSubview(labelToggleComponent)
        
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Journal Title"
        textField.addAction(UIAction { [weak self] _ in
            self?.updateSaveButtonState()
        }, for: .editingChanged)
        return textField
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Journal Body"
        textView.delegate = self
        return textView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "face.smiling")
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Entry"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        mainContainer.addArrangedSubview(ratingView)
        mainContainer.addArrangedSubview(toggleView)
        mainContainer.addArrangedSubview(titleTextField)
        mainContainer.addArrangedSubview(bodyTextView)
        mainContainer.addArrangedSubview(imageView)
        
        view.addSubview(mainContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            mainContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            ratingView.widthAnchor.constraint(equalToConstant: 252),
            ratingView.heightAnchor.constraint(equalToConstant: 44),
            
            toggleView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            toggleView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            
            titleTextField.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            
            bodyTextView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            bodyTextView.heightAnchor.constraint(equalToConstant: 128),
            
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image: \(info)")
        }
        
        let smallerImage = selectedImage.preparingThumbnail(of: CGSize(width: 300, height: 300))
        imageView.image = smallerImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    // MARK: - Methods
    func updateSaveButtonState() {
        if locationSwitchIsOn {
            guard let title = titleTextField.text, !title.isEmpty,
                  let body = bodyTextView.text, !body.isEmpty,
                  let _ = currentLocation else {
                saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
        } else {
            guard let title = titleTextField.text, !title.isEmpty,
                  let body = bodyTextView.text, !body.isEmpty else {
                saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
        }
    }
    
    @objc func save() {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextView.text, !body.isEmpty else {
            return
        }
        let rating = ratingView.rating
        let lat = currentLocation?.coordinate.latitude
        let long = currentLocation?.coordinate.longitude
        
        let journalEntry = JournalEntry(rating: rating, title: title, body: body, photo: imageView.image, latitude: lat, longitude: long)!
        
        delegate?.saveJournalEntry(journalEntry)
        dismiss(animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myCurrentLocation = locations.first {
            currentLocation = myCurrentLocation
            if let label = toggleView.viewWithTag(LABEL_VIEW_TAG) as? UILabel {
                label.text = "Done"
            }
            updateSaveButtonState()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
