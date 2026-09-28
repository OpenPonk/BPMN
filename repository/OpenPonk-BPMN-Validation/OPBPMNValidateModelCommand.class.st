"
A model command that validates BPMN workflow structural rules and highlights syntactic violations on the canvas.
"
Class {
	#name : 'OPBPMNValidateModelCommand',
	#superclass : 'OPBPMNCommand',
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'activation' }
OPBPMNValidateModelCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPBPMNValidationMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPBPMNValidateModelCommand >> defaultMenuItemName [
	"Answers the display name of the validate model command."
	^ 'Validate model'
]

{ #category : 'execution' }
OPBPMNValidateModelCommand >> execute [
	"Validates the BPMN model and updates visual validation highlights in the diagram."
	OPBPMNValidationUI
		updateValidatedElements: (OPBPMNValidationController new validate: self model)
		using: self diagramController
]
