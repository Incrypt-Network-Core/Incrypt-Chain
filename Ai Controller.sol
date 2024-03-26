pragma solidity ^0.8.7;

// AIController
//
// This smart contract implements the AIController functions that facilitate
// training & prediction services.

contract AIController {
    address owner;

    // Training
    
    mapping(address => bool) public trainers;

    mapping(address => mapping(bytes32 => uint256)) public traineeEpochsTrained;

    // Prediction

    mapping(address => bool) public predictors;

    mapping(address => uint256) public totalPredictionsForTrainer;

    uint256 public epochDurationInSeconds;

    constructor() {
        owner = msg.sender;

        // Default configuration

        epochDurationInSeconds = 24 hours;
    }

    // Training

    modifier onlyTrainers() {
        require(
            trainers[msg.sender],
            "Address is not registered as a trainer"
        );

        _;
    }

    function registerTrainer(address trainer) external {
        require(!trainers[trainer], "Address is already a registered trainer");

        trainers[trainer] = true;
    }

    function unregisterTrainer(address trainer) external onlyTrainer(trainer) {
        delete trainers[trainer];

        // Reset epochs trained

        for (uint256 i = 0; i < uint256(numEpochs); i++) {
            delete traineeEpochsTrained[trainer][i];
        }
    }

    // Prediction

    modifier onlyPredictors() {
        require(
            predictors[msg.sender],
            "Address is not registered as a predictor"
        );

        _;
    }

    function registerPredictor(address predictor) external {
        require(!predictors[predictor], "Address is already a registered predictor");

        predictors[predictor] = true;
    }

    function unregisterPredictor(address predictor) external onlyPredictor(predictor) {
        delete predictors[predictor];

        // Reset total number of performed predictions

        totalPredictionsForTrainer[predictor] = 0;
    }

    function trainModel(
        bytes32 modelIdentifier,
        uint256 numEpochs,
        uint256 epochDuration,
        bytes memory inputData
    )