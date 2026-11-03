"
I manage the user interface for displaying validation results. I render an inspector table and highlight the offending diagram elements when a user selects a specific validation warning.
"
Class {
	#name : 'OPBPMNValidationResultsUI',
	#superclass : 'Object',
	#instVars : [
		'controller',
		'validationResults',
		'highlighted',
		'prevColor'
	],
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'instance creation' }
OPBPMNValidationResultsUI class >> createUIFor: aVerificationResults withControllers: aControllers [
	| verUI |
	verUI := self new.
	verUI validationResults: aVerificationResults;
	controller: aControllers.
	^ verUI.
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> changeElementColor: anElement toColor: aColor [
	| matchingControllers |
	aColor ifNil: [ ^ self ].
	matchingControllers := (self controller controllers select: [ :eachController |
		eachController model = anElement ]) asArray.
	matchingControllers ifNotEmpty: [ :foundControllers |
		OPBPMNValidationUI
			changeElementColorTo: aColor
			using: foundControllers first ]
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> controller [
	^ controller .
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> controller: aController [
	controller := aController.
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> getElementColor: anElement [
	self controller controllers
		detect: [ :eachController | eachController model = anElement ]
		ifFound: [ :matchingController |
			(matchingController respondsTo: #diagramElement) ifFalse: [ ^ nil ].
			(matchingController diagramElement respondsTo: #borderColor)
				ifTrue: [ ^ matchingController diagramElement borderColor ].
			^ Color black ].
	^ nil
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> highlightElement: anElement [
	(highlighted isNotNil and: [ prevColor isNotNil ]) ifTrue: [
		self changeElementColor: highlighted toColor: prevColor ].
	highlighted := anElement.
	prevColor := self getElementColor: anElement.
	prevColor ifNotNil: [
		self changeElementColor: anElement toColor: Color green ]
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> highlighted [
	^ highlighted
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> inspectorDocumentationReferenceIn: aBuilder [

	<inspectorPresentationOrder: -14 title: 'Documentation'>
	^ aBuilder newTable
		  beResizable;
		  items:
			  { 'https://github.com/OpenPonk/OpenPonk-BPMN/blob/dev-validations-docs/docs/validation-rules.md' };
		  addColumn:
			  (SpLinkTableColumn
				   title: 'Rules'
				   evaluated: #asString
				   url: #asString) yourself
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> inspectorTableIn: aBuilder [

	<inspectorPresentationOrder: -15 title: 'Results'>
	^ aBuilder newTable
		  beResizable;
		  items: self validationResults results asArray;
		  whenSelectedDo: [ :item | self notifySelectChanged: item ];
		  addColumn: (SpStringTableColumn new
				   title: 'Severity';
				   evaluated: #severity;
				   width: 55);
		  addColumn:
		  (SpStringTableColumn title: 'Object' evaluated: #objectReference);
		  addColumn:
		  (SpStringTableColumn title: 'Reason' evaluated: #messageText)
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> notifySelectChanged: aSelection [
	aSelection ifNotNil: [ self highlightElement: aSelection objectReference. ].
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> validationResults [
	^ validationResults.
]

{ #category : 'accessing' }
OPBPMNValidationResultsUI >> validationResults: aValidationResults [ 
	validationResults := aValidationResults.
]
