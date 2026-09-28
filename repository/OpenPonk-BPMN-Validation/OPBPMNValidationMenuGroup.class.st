"
A Commander 1 menu group that structures BPMN model validation and highlight clearance commands.
"
Class {
	#name : 'OPBPMNValidationMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'accessing' }
OPBPMNValidationMenuGroup >> icon [
	"Answers the icon form for the validations submenu."
	^ OPBPMNIcon current logo
]

{ #category : 'testing' }
OPBPMNValidationMenuGroup >> isInlined [
	"Answers false to render this group as a nested submenu."
	^ false
]

{ #category : 'accessing' }
OPBPMNValidationMenuGroup >> name [
	"Answers the display name of the validation group."
	^ 'Validations'
]

{ #category : 'accessing' }
OPBPMNValidationMenuGroup >> order [
	"Answers the order priority within the parent menu."
	^ 20
]
