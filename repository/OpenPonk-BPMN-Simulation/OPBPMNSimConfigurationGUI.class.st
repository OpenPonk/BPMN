"
Spec2 presenter embedded in the right scrollable sidebar of OPSimulationGUI for configuring BPMN branching gateway routing (exclusive radio groups and inclusive/complex checkboxes). Displays deterministic gateway and branch labels with readable fallbacks and warns when an inclusive or complex gateway has no active outgoing branch.
"
Class {
	#name : 'OPBPMNSimConfigurationGUI',
	#superclass : 'OPSimulationConfigurationGUI',
	#instVars : [
		'gatewayEntries',
		'isRefreshing'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'layout' }
OPBPMNSimConfigurationGUI >> buildConfigurationLayout [

	| mainLayout |
	mainLayout := SpBoxLayout newTopToBottom
		              borderWidth: 8;
		              spacing: 10;
		              yourself.
	self gatewayEntries do: [ :eachEntry | mainLayout add: (self buildSectionLayoutForEntry: eachEntry) expand: false ].
	^ mainLayout
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> buildEntryForGateway: aGatewaySimulator [

	| headerLabel orderedOutgoing branches warningLabel |
	headerLabel := self newLabel
		               label: (self labelForGateway: aGatewaySimulator);
		               yourself.
	orderedOutgoing := self orderedOutgoingForGateway: aGatewaySimulator.
	branches := OrderedCollection new.
	warningLabel := nil.
	(self isExclusiveGateway: aGatewaySimulator) ifTrue: [
		branches := self buildExclusiveBranchesFor: aGatewaySimulator orderedOutgoing: orderedOutgoing ].
	(self isInclusiveGateway: aGatewaySimulator) ifTrue: [
			branches := self buildInclusiveBranchesFor: aGatewaySimulator orderedOutgoing: orderedOutgoing.
			warningLabel := self newLabel
				                label: (self warningMessageForGateway: aGatewaySimulator);
				                yourself ].
	^ Dictionary newFrom: {
			  (#gateway -> aGatewaySimulator).
			  (#headerLabel -> headerLabel).
			  (#branches -> branches).
			  (#warningLabel -> warningLabel) }
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> buildExclusiveBranchesFor: aGatewaySimulator orderedOutgoing: anOrderedCollection [

	| branches buttons |
	branches := anOrderedCollection withIndexCollect: [ :eachFlow :index |
			            eachFlow -> (self newRadioButton
				             label: (self labelForOutgoingFlow: eachFlow index: index);
				             yourself) ].
	buttons := branches collect: #value.
	buttons size > 1 ifTrue: [ buttons first associatedRadioButtons: buttons allButFirst ].
	buttons ifNotEmpty: [
			aGatewaySimulator outgoingActive ifEmpty: [ buttons first initialStateNotSet ] ifNotEmpty: [ :activeFlows |
					| activeIndex |
					activeIndex := anOrderedCollection indexOf: activeFlows first ifAbsent: [ 0 ].
					activeIndex > 0
						ifTrue: [ (buttons at: activeIndex) state: true ]
						ifFalse: [ buttons first initialStateNotSet ] ] ].
	^ branches
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> buildInclusiveBranchesFor: aGatewaySimulator orderedOutgoing: anOrderedCollection [

	^ anOrderedCollection withIndexCollect: [ :eachFlow :index |
			  eachFlow -> (self newCheckBox
				   label: (self labelForOutgoingFlow: eachFlow index: index);
				   state: (aGatewaySimulator outgoingActive includes: eachFlow);
				   yourself) ]
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> buildSectionLayoutForEntry: anEntry [

	| sectionLayout branchesLayout warningLabel |
	sectionLayout := SpBoxLayout newTopToBottom
		                 spacing: 4;
		                 add: (anEntry at: #headerLabel) expand: false;
		                 yourself.
	branchesLayout := SpBoxLayout newTopToBottom
		                  borderWidth: 4;
		                  spacing: 2;
		                  yourself.
	(anEntry at: #branches) do: [ :eachPair | branchesLayout add: eachPair value expand: false ].
	sectionLayout add: branchesLayout expand: false.
	warningLabel := anEntry at: #warningLabel.
	warningLabel ifNotNil: [ sectionLayout add: warningLabel expand: false ].
	^ sectionLayout
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> connectExclusiveBranches: aBranchCollection forGateway: aGatewaySimulator [

	aBranchCollection do: [ :eachPair |
			eachPair value whenActivatedDo: [
				isRefreshing ifFalse: [ aGatewaySimulator outgoingActive: (OrderedCollection with: eachPair key) ] ] ]
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> connectInclusiveBranches: aBranchCollection forGateway: aGatewaySimulator warningLabel: aWarningLabel [

	aBranchCollection do: [ :eachPair |
			eachPair value
				whenActivatedDo: [
						isRefreshing ifFalse: [
									(aGatewaySimulator outgoingActive includes: eachPair key) ifFalse: [ aGatewaySimulator outgoingActive add: eachPair key ].
									self updateWarningLabel: aWarningLabel forGateway: aGatewaySimulator ] ];
				whenDeactivatedDo: [
						isRefreshing ifFalse: [
									aGatewaySimulator outgoingActive remove: eachPair key ifAbsent: [ ].
									self updateWarningLabel: aWarningLabel forGateway: aGatewaySimulator ] ] ]
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> connectPresenters [

	self gatewayEntries do: [ :eachEntry | self connectPresentersForEntry: eachEntry ]
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> connectPresentersForEntry: anEntry [

	| gatewaySimulator |
	gatewaySimulator := anEntry at: #gateway.
	(self isExclusiveGateway: gatewaySimulator) ifTrue: [
			self connectExclusiveBranches: (anEntry at: #branches) forGateway: gatewaySimulator.
			^ self ].
	self connectInclusiveBranches: (anEntry at: #branches) forGateway: gatewaySimulator warningLabel: (anEntry at: #warningLabel)
]

{ #category : 'accessing' }
OPBPMNSimConfigurationGUI >> emptyStateMessage [

	^ 'No configurable branching gateways in this diagram.'
]

{ #category : 'accessing' }
OPBPMNSimConfigurationGUI >> gatewayEntries [

	^ gatewayEntries
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> gatewayTypeDisplayNameFor: aGatewayModel [

	| gatewayType |
	gatewayType := aGatewayModel type.
	(gatewayType = OPBPMNNodeType ExclusiveEmpty or: [ gatewayType = OPBPMNNodeType Exclusive ]) ifTrue: [ ^ 'Exclusive' ].
	gatewayType = OPBPMNNodeType Eventbased ifTrue: [ ^ 'Event-based' ].
	gatewayType = OPBPMNNodeType Inclusive ifTrue: [ ^ 'Inclusive' ].
	gatewayType = OPBPMNNodeType Complex ifTrue: [ ^ 'Complex' ].
	gatewayType = OPBPMNNodeType Parallel ifTrue: [ ^ 'Parallel' ].
	^ gatewayType asString
]

{ #category : 'testing' }
OPBPMNSimConfigurationGUI >> hasConfigurableItems [

	^ self gatewayEntries isNotEmpty
]

{ #category : 'initialization' }
OPBPMNSimConfigurationGUI >> initializePresenters [

	super initializePresenters.
	isRefreshing := false.
	self rebuildGatewayEntries
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> isExclusiveGateway: aGatewaySimulator [

	^ {
		  OPBPMNNodeType ExclusiveEmpty.
		  OPBPMNNodeType Exclusive.
		  OPBPMNNodeType Eventbased } includes: aGatewaySimulator model type
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> isInclusiveGateway: aGatewaySimulator [

	^ {
		  OPBPMNNodeType Inclusive.
		  OPBPMNNodeType Complex } includes: aGatewaySimulator model type
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> labelForGateway: aGatewaySimulator [

	| trimmedName typeLabel |
	trimmedName := (aGatewaySimulator model name ifNil: [ '' ]) trimBoth.
	typeLabel := self gatewayTypeDisplayNameFor: aGatewaySimulator model.
	trimmedName ifEmpty: [ ^ typeLabel , ' gateway' ].
	^ String streamContents: [ :stream |
			  stream nextPutAll: trimmedName.
			  stream nextPutAll: ' ('.
			  stream nextPutAll: typeLabel.
			  stream nextPut: $) ]
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> labelForOutgoingFlow: aFlowSimulator index: anInteger [

	| flowName targetName |
	flowName := (aFlowSimulator model name ifNil: [ '' ]) trimBoth.
	targetName := (aFlowSimulator target ifNil: [ '' ] ifNotNil: [ :targetSimulator | targetSimulator model name ifNil: [ '' ] ])
		              trimBoth.
	flowName ifNotEmpty: [
			targetName ifEmpty: [ ^ flowName ].
			^ String streamContents: [ :stream |
					  stream nextPutAll: flowName.
					  stream nextPutAll: ' (→ '.
					  stream nextPutAll: targetName.
					  stream nextPut: $) ] ].
	targetName ifNotEmpty: [ ^ '→ ' , targetName ].
	^ '→ ' , (self targetFallbackNameFor: aFlowSimulator target index: anInteger)
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> orderedOutgoingForGateway: aGatewaySimulator [

	| modelOutgoing remaining ordered |
	modelOutgoing := aGatewaySimulator model outgoing.
	remaining := aGatewaySimulator outgoing copy asOrderedCollection.
	ordered := OrderedCollection new.
	modelOutgoing do: [ :eachFlowModel |
			remaining detect: [ :eachFlowSimulator | eachFlowSimulator model == eachFlowModel ] ifFound: [ :matchedSimulator |
					ordered add: matchedSimulator.
					remaining remove: matchedSimulator ] ].
	ordered addAll: remaining.
	^ ordered
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> rebuildGatewayEntries [

	diagramSimulator ifNil: [
			gatewayEntries := OrderedCollection new.
			^ self ].
	gatewayEntries := diagramSimulator configurableGateways
		                  collect: [ :eachGateway | self buildEntryForGateway: eachGateway ]
		                  as: OrderedCollection
]

{ #category : 'updating' }
OPBPMNSimConfigurationGUI >> refreshFromSimulator [

	| currentGateways configuredGateways |
	currentGateways := diagramSimulator ifNil: [ #(  ) ] ifNotNil: [ :simulator | simulator configurableGateways asArray ].
	configuredGateways := self gatewayEntries collect: [ :eachEntry | eachEntry at: #gateway ] as: Array.
	currentGateways = configuredGateways ifFalse: [
			self
				rebuildGatewayEntries;
				connectPresenters.
			^ self ].
	self synchronizeControlsFromSimulator
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> synchronizeControlsFromSimulator [

	isRefreshing := true.
	[ self gatewayEntries do: [ :eachEntry | self synchronizeEntry: eachEntry ] ] ensure: [ isRefreshing := false ]
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> synchronizeEntry: anEntry [

	| gatewaySimulator branches warningLabel |
	gatewaySimulator := anEntry at: #gateway.
	branches := anEntry at: #branches.
	warningLabel := anEntry at: #warningLabel.
	(self isExclusiveGateway: gatewaySimulator) ifTrue: [
			gatewaySimulator outgoingActive ifNotEmpty: [ :activeFlows |
				branches detect: [ :eachPair | eachPair key == activeFlows first ] ifFound: [ :matchedPair | matchedPair value state: true ] ].
			^ self ].
	branches do: [ :eachPair | eachPair value state: (gatewaySimulator outgoingActive includes: eachPair key) ].
	self updateWarningLabel: warningLabel forGateway: gatewaySimulator
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> targetFallbackNameFor: aTargetSimulator index: anInteger [

	| targetModel |
	aTargetSimulator ifNil: [ ^ 'Branch ' , anInteger asString ].
	targetModel := aTargetSimulator model.
	(targetModel isKindOf: OPBPMNGatewayModel) ifTrue: [ ^ (self gatewayTypeDisplayNameFor: targetModel) , ' gateway' ].
	(targetModel isKindOf: OPBPMNEndEventModel) ifTrue: [ ^ 'End event' ].
	(targetModel isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ ^ 'Intermediate event' ].
	((targetModel isKindOf: OPBPMNSubProcessModel) or: [ targetModel isKindOf: OPBPMNCollapsedSubProcessModel ]) ifTrue: [
		^ 'Sub-process' ].
	(targetModel isKindOf: OPBPMNActivityModel) ifTrue: [ ^ 'Activity' ].
	^ 'Branch ' , anInteger asString
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> updateWarningLabel: aLabelPresenter forGateway: aGatewaySimulator [

	aLabelPresenter label: (self warningMessageForGateway: aGatewaySimulator)
]

{ #category : 'private' }
OPBPMNSimConfigurationGUI >> warningMessageForGateway: aGatewaySimulator [

	^ aGatewaySimulator canSendBpmnTokens
		  ifTrue: [ '' ]
		  ifFalse: [ 'Warning: no active branch — tokens will stop here' ]
]
