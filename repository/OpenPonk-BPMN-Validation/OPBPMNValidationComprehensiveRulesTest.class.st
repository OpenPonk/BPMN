"
Verifies semantic and structural validation rules for BPMN models, covering pool containment, gateway branching, boundary events, and message flows.
"
Class {
	#name : 'OPBPMNValidationComprehensiveRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'model'
	],
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNValidationComprehensiveRulesTest >> setUp [
	super setUp.
	controller := OPBPMNValidationController new.
	model := OPBPMNModel new
]

{ #category : 'running' }
OPBPMNValidationComprehensiveRulesTest >> tearDown [
	controller := nil.
	model := nil.
	super tearDown
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testAN06TriggeredWhenSingleConditionalFlowHasAlsoAssociation [
	| task targetTask condFlow annotation association results |
	task := OPBPMNActivityModel new name: 'Task'.
	targetTask := OPBPMNActivityModel new name: 'Target'.
	condFlow := (OPBPMNFlowModel from: task to: targetTask)
		type: 'Conditional';
		yourself.
	task addFlow: condFlow.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: task.
	association target: annotation.
	task addAssociation: association.
	results := AN06OnlyConditionalFlow validate: task withModel: model.
	self
		deny: results isEmpty
		description: 'Node with a single conditional sequence flow must trigger AN06 even when an association is connected'
]

{ #category : 'tests - pools' }
OPBPMNValidationComprehensiveRulesTest >> testBlackBoxPoolWithAnnotationRemainsBlackBoxAndDoesNotTriggerPR02OrPR05 [
	| poolCustomer poolVendor annotation msgFlow results |
	poolCustomer := OPBPMNPoolModel new name: 'Customer'.
	annotation := OPBPMNAnnotationModel new text: 'External B2B partner'.
	poolCustomer add: annotation.
	poolVendor := OPBPMNPoolModel new name: 'Vendor'.
	msgFlow := (OPBPMNMessageFlowModel from: poolCustomer to: poolVendor)
		name: 'Order';
		yourself.
	poolCustomer addFlow: msgFlow.
	poolVendor addFlow: msgFlow.
	model add: poolCustomer; add: poolVendor.

	self
		assert: poolCustomer isBlackBox
		description: 'Pool containing only an annotation must still be recognized as a Black-Box pool'.
	results := controller validate: model.
	self
		deny: (results hasErrors: poolCustomer)
		description: 'Black-Box pool with annotation must not trigger PR02 or PR06 errors'.
	self
		deny: (results hasErrors: poolVendor)
		description: 'Target Black-Box pool must not trigger PR05 error'
]

{ #category : 'tests - controller' }
OPBPMNValidationComprehensiveRulesTest >> testBoundaryEventAttachedToActivityIsValidated [
	| task boundaryEvent results |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'Boundary Error'.
	boundaryEvent type: OPBPMNNodeType Error.
	task add: boundaryEvent.
	model add: task.
	results := controller validate: model.
	self
		assert: (results hasErrors: boundaryEvent)
		description: 'Boundary event attached to activity must be validated by validation controller'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testBoundaryEventMessageFlowValidationRules [
	| pool task receiveBoundaryWithoutMsg receiveBoundaryWithMsg timerBoundaryWithMsg resultsMissing resultsValid |
	pool := OPBPMNPoolModel new name: 'External'.
	task := OPBPMNActivityModel new name: 'Task'.
	receiveBoundaryWithoutMsg := OPBPMNBoundaryEventModel new
		name: 'Msg Catch Missing';
		type: OPBPMNNodeType Receive;
		yourself.
	receiveBoundaryWithMsg := OPBPMNBoundaryEventModel new
		name: 'Msg Catch Valid';
		type: OPBPMNNodeType Receive;
		yourself.
	receiveBoundaryWithMsg addFlow: (OPBPMNMessageFlowModel from: pool to: receiveBoundaryWithMsg).
	timerBoundaryWithMsg := OPBPMNBoundaryEventModel new
		name: 'Timer With Msg';
		type: OPBPMNNodeType Timer;
		yourself.
	timerBoundaryWithMsg addFlow: (OPBPMNMessageFlowModel from: pool to: timerBoundaryWithMsg).
	task
		add: receiveBoundaryWithoutMsg;
		add: receiveBoundaryWithMsg;
		add: timerBoundaryWithMsg.
	model
		add: task;
		add: pool.

	resultsMissing := controller validate: model.
	self
		assert: (resultsMissing hasWarnings: receiveBoundaryWithoutMsg)
		description: 'Receive boundary event without incoming message flow must produce validation warning'.
	self
		deny: (resultsMissing selectErrors anySatisfy: [ :each |
			each objectReference == receiveBoundaryWithoutMsg and: [ each messageText includesSubstring: 'IE01' ] ])
		description: 'Receive boundary event without incoming message flow must not produce IE01 error'.
	resultsValid := resultsMissing selectWarnings select: [ :each |
		each objectReference == receiveBoundaryWithMsg and: [ each messageText includesSubstring: 'IE01' ] ].
	self
		assert: resultsValid isEmpty
		description: 'Receive boundary event with incoming message flow must not have message flow validation warning'.
	self
		assert: (resultsMissing selectErrors anySatisfy: [ :each |
			each objectReference == timerBoundaryWithMsg and: [ (each messageText includesSubstring: 'BE02') not ] ])
		description: 'Timer boundary event with incoming message flow must trigger IE03 message flow validation error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testBoundaryEventWithDataFlowOrAssociationDoesNotTriggerBE02 [
	| boundaryEvent task dataObject flow dataFlow results |
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'Timer'.
	boundaryEvent type: OPBPMNNodeType Timer.
	task := OPBPMNActivityModel new name: 'Task'.
	flow := OPBPMNFlowModel from: boundaryEvent to: task.
	boundaryEvent addFlow: flow.
	dataObject := OPBPMNDataObjectModel new name: 'Data'.
	dataFlow := OPBPMNDataFlowModel from: boundaryEvent to: dataObject.
	boundaryEvent addFlow: dataFlow.
	results := BE02OneSequenceFlow validate: boundaryEvent withModel: model.
	self
		assert: results isEmpty
		description: 'Boundary event with one sequence flow and one data flow must not trigger BE02 error'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testCollaborationWithTwoPoolsDoesNotProducePR03Warning [
	| pool1 pool2 task1 task2 start1 start2 results |
	pool1 := OPBPMNPoolModel new name: 'Pool 1'.
	task1 := OPBPMNActivityModel new name: 'Task 1'.
	start1 := OPBPMNStartEventModel new name: 'Start 1'.
	pool1 add: start1; add: task1.
	pool2 := OPBPMNPoolModel new name: 'Pool 2'.
	task2 := OPBPMNActivityModel new name: 'Task 2'.
	start2 := OPBPMNStartEventModel new name: 'Start 2'.
	pool2 add: start2; add: task2.
	model add: pool1; add: pool2.
	results := controller validate: model.
	self
		deny: (results selectWarnings anySatisfy: [ :each | each messageText includesSubstring: 'PR03' ])
		description: 'Valid collaboration with multiple pools must not produce PR03 warning'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testCompensationBoundaryEventAndCompensationActivityValidationRules [
	| task compBoundaryUnconnected compBoundaryConnected compTask validAssoc invalidSeqFlow targetTask resultsUnconnected resultsValid resultsWithSeqFlow |
	task := OPBPMNActivityModel new name: 'Main Task'.
	compBoundaryUnconnected := OPBPMNBoundaryEventModel new
		name: 'Unconnected Comp';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	compBoundaryConnected := OPBPMNBoundaryEventModel new
		name: 'Connected Comp';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	compTask := OPBPMNActivityModel new name: 'Undo Action'.
	validAssoc := OPBPMNAssociationModel new
		source: compBoundaryConnected;
		target: compTask;
		associationDirection: OPBPMNAssociationModel associationDirectionOne;
		yourself.
	compBoundaryConnected addAssociation: validAssoc.
	compTask addAssociation: validAssoc.

	resultsUnconnected := BE02OneSequenceFlow validate: compBoundaryUnconnected withModel: model.
	self
		deny: resultsUnconnected isEmpty
		description: 'Unconnected compensation boundary event without outgoing association must trigger BE02 error'.

	resultsValid := (BE02OneSequenceFlow validate: compBoundaryConnected withModel: model)
		, (AN01FlowNodeIncomingFlow validate: compTask withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: compTask withModel: model).
	self
		assert: resultsValid isEmpty
		description: 'Compensation boundary event connected via association to compensation activity without sequence flows must be valid'.

	targetTask := OPBPMNActivityModel new name: 'Next Task'.
	invalidSeqFlow := OPBPMNFlowModel from: compTask to: targetTask.
	compTask addFlow: invalidSeqFlow.
	resultsWithSeqFlow := (AN01FlowNodeIncomingFlow validate: compTask withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: compTask withModel: model).
	self
		deny: resultsWithSeqFlow isEmpty
		description: 'Compensation activity connected to a sequence flow must trigger validation error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testCompensationBoundaryEventWithOutgoingSequenceFlowTriggersBE02Error [
	| boundaryEvent targetTask seqFlow results |
	boundaryEvent := OPBPMNBoundaryEventModel new
		name: 'Comp';
		type: OPBPMNNodeType CatchCompensation;
		yourself.
	targetTask := OPBPMNActivityModel new name: 'Handler'.
	seqFlow := OPBPMNFlowModel from: boundaryEvent to: targetTask.
	boundaryEvent addFlow: seqFlow.
	results := BE02OneSequenceFlow validate: boundaryEvent withModel: model.
	self
		deny: results isEmpty
		description: 'Compensation boundary event with an outgoing sequence flow must trigger BE02 error'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testCompensationSubProcessDoesNotTriggerAN01OrAN02Errors [
	| compSubProcess adHocSubProcess innerTask results |
	compSubProcess := OPBPMNCollapsedSubProcessModel new
		name: 'Compensate Order';
		type: OPBPMNNodeType MarkerCompensation;
		yourself.
	adHocSubProcess := OPBPMNSubProcessModel new
		name: 'AdHoc Group';
		type: OPBPMNNodeType MarkerAdhoc;
		yourself.
	innerTask := OPBPMNActivityModel new name: 'AdHoc Task'.
	adHocSubProcess add: innerTask.

	results := (AN01FlowNodeIncomingFlow validate: compSubProcess withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: compSubProcess withModel: model)
		, (AN01FlowNodeIncomingFlow validate: innerTask withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: innerTask withModel: model).
	self
		assert: results isEmpty
		description: 'Compensation subprocess and tasks inside Ad-Hoc subprocess must not require incoming/outgoing sequence flows'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testEndEventWithAssociationDoesNotTriggerEE04 [
	| endEvent annotation association results |
	endEvent := OPBPMNEndEventModel new name: 'End'.
	endEvent type: OPBPMNNodeType None.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: endEvent.
	association target: annotation.
	endEvent addAssociation: association.
	results := EE04MessageOther validate: endEvent withModel: model.
	self
		assert: results isEmpty
		description: 'End event connected to annotation via association must not trigger EE04 error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testErrorBoundaryEventAttachedToTaskDoesNotTriggerBE03Warning [
	| task boundaryEvent results |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'Error Catch'.
	boundaryEvent type: OPBPMNNodeType Error.
	task add: boundaryEvent.
	results := BE03BoundaryErrorSibling validate: boundaryEvent withModel: model.
	self
		assert: results isEmpty
		description: 'Error boundary event attached to a task must not trigger BE03 subprocess warning'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testEscalationBoundaryEventAttachedToTaskDoesNotTriggerBE04Warning [
	| task boundaryEvent results |
	task := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new name: 'Escalation Catch'.
	boundaryEvent type: OPBPMNNodeType Escalation.
	task add: boundaryEvent.
	results := BE04BoundaryEscalationSibling validate: boundaryEvent withModel: model.
	self
		assert: results isEmpty
		description: 'Escalation boundary event attached to a task must not trigger BE04 subprocess warning'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testEscalationOrCompensationOrNonInterruptingStartEventAtTopLevelTriggersSE05Error [
	| escalationStart compStart nonInterruptingTimerStart subProcess validEscalationInSub resultsEscalation resultsComp resultsNonInterrupting resultsValidInSub |
	escalationStart := OPBPMNStartEventModel new
		name: 'Esc Start';
		type: OPBPMNNodeType Escalation;
		yourself.
	compStart := OPBPMNStartEventModel new
		name: 'Comp Start';
		type: OPBPMNNodeType Compensation;
		yourself.
	nonInterruptingTimerStart := OPBPMNStartEventModel new
		name: 'NI Timer';
		type: OPBPMNNodeType Timer;
		isNonInterrupting: true;
		yourself.
	model add: escalationStart; add: compStart; add: nonInterruptingTimerStart.

	subProcess := OPBPMNSubProcessModel new name: 'Event SubProcess'.
	validEscalationInSub := OPBPMNStartEventModel new
		name: 'Sub Esc Start';
		type: OPBPMNNodeType Escalation;
		isNonInterrupting: true;
		yourself.
	subProcess add: validEscalationInSub.
	model add: subProcess.

	resultsEscalation := SE05Error validate: escalationStart withModel: model.
	resultsComp := SE05Error validate: compStart withModel: model.
	resultsNonInterrupting := SE05Error validate: nonInterruptingTimerStart withModel: model.
	resultsValidInSub := SE05Error validate: validEscalationInSub withModel: model.

	self
		deny: resultsEscalation isEmpty
		description: 'Top-level Escalation start event must trigger SE05 error'.
	self
		deny: resultsComp isEmpty
		description: 'Top-level Compensation start event must trigger SE05 error'.
	self
		deny: resultsNonInterrupting isEmpty
		description: 'Top-level non-interrupting start event must trigger SE05 error'.
	self
		assert: resultsValidInSub isEmpty
		description: 'Escalation non-interrupting start event inside a subprocess must not trigger SE05 error'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testEventBasedGatewayFollowedByLinkOrEscalationOrCompensationEventTriggersGW04Error [
	| gateway timerCatch linkCatch flow1 flow2 results |
	gateway := OPBPMNGatewayModel new
		name: 'Event GW';
		type: OPBPMNNodeType Eventbased;
		yourself.
	timerCatch := OPBPMNIntermediateEventModel new
		name: 'Timer';
		type: OPBPMNNodeType Timer;
		yourself.
	linkCatch := OPBPMNIntermediateEventModel new
		name: 'Link';
		type: OPBPMNNodeType Link;
		yourself.
	flow1 := OPBPMNFlowModel from: gateway to: timerCatch.
	flow2 := OPBPMNFlowModel from: gateway to: linkCatch.
	gateway addFlow: flow1; addFlow: flow2.
	results := GW04Eventbased validate: gateway withModel: model.
	self
		deny: results isEmpty
		description: 'Event-based gateway connected to a Link intermediate event must trigger GW04 error'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testEventBasedGatewayFollowedByTimerCatchEventDoesNotTriggerGW04 [
	| gateway timerEvent1 timerEvent2 flow1 flow2 results |
	gateway := OPBPMNGatewayModel new name: 'Event Gateway'.
	gateway type: OPBPMNNodeType Eventbased.
	timerEvent1 := OPBPMNIntermediateEventModel new name: 'Timer 1'.
	timerEvent1 type: OPBPMNNodeType Timer.
	timerEvent2 := OPBPMNIntermediateEventModel new name: 'Timer 2'.
	timerEvent2 type: OPBPMNNodeType Timer.
	flow1 := OPBPMNFlowModel from: gateway to: timerEvent1.
	flow2 := OPBPMNFlowModel from: gateway to: timerEvent2.
	gateway addFlow: flow1; addFlow: flow2.
	results := GW04Eventbased validate: gateway withModel: model.
	self
		assert: results isEmpty
		description: 'Event-based gateway followed by intermediate timer catch events must not trigger GW04 error'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testEventBasedGatewayRejectsMixingReceiveTaskAndMessageEventOrReceiveTaskWithBoundaryEventInGW04 [
	| gwMixed receiveTask msgCatchEvent gwBoundary receiveTaskWithBoundary boundaryTimer resultsMixed resultsBoundary |
	gwMixed := OPBPMNGatewayModel new
		name: 'Event GW Mixed';
		type: OPBPMNNodeType Eventbased;
		yourself.
	receiveTask := OPBPMNActivityModel new
		name: 'Receive Order';
		type: OPBPMNNodeType Receive;
		yourself.
	msgCatchEvent := OPBPMNIntermediateEventModel new
		name: 'Order Msg';
		type: OPBPMNNodeType Receive;
		yourself.
	gwMixed
		addFlow: (OPBPMNFlowModel from: gwMixed to: receiveTask);
		addFlow: (OPBPMNFlowModel from: gwMixed to: msgCatchEvent).

	gwBoundary := OPBPMNGatewayModel new
		name: 'Event GW Boundary';
		type: OPBPMNNodeType Eventbased;
		yourself.
	receiveTaskWithBoundary := OPBPMNActivityModel new
		name: 'Receive With Timeout';
		type: OPBPMNNodeType Receive;
		yourself.
	boundaryTimer := OPBPMNBoundaryEventModel new
		name: 'Timeout';
		type: OPBPMNNodeType Timer;
		yourself.
	receiveTaskWithBoundary add: boundaryTimer.
	gwBoundary addFlow: (OPBPMNFlowModel from: gwBoundary to: receiveTaskWithBoundary).

	resultsMixed := GW04Eventbased validate: gwMixed withModel: model.
	resultsBoundary := GW04Eventbased validate: gwBoundary withModel: model.

	self
		deny: resultsMixed isEmpty
		description: 'Event-Based Gateway mixing Receive Task and Message Intermediate Event must trigger GW04 error'.
	self
		deny: resultsBoundary isEmpty
		description: 'Event-Based Gateway connected to a Receive Task with a Boundary Event must trigger GW04 error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testEventSubProcessAndNonInterruptingErrorStartEventInSubProcessValidation [
	| eventSubProcess validStart innerTask endEvent invalidSubProcess invalidErrorStart flow1 flow2 resultsValidSub resultsInvalidStart |
	eventSubProcess := OPBPMNSubProcessModel new name: 'SLA Monitor'.
	validStart := OPBPMNStartEventModel new
		name: 'SLA Tick';
		type: OPBPMNNodeType Timer;
		isNonInterrupting: true;
		yourself.
	innerTask := OPBPMNActivityModel new name: 'Notify'.
	endEvent := OPBPMNEndEventModel new name: 'Done'.
	flow1 := OPBPMNFlowModel from: validStart to: innerTask.
	flow2 := OPBPMNFlowModel from: innerTask to: endEvent.
	validStart addFlow: flow1.
	innerTask addFlow: flow1; addFlow: flow2.
	endEvent addFlow: flow2.
	eventSubProcess add: validStart; add: innerTask; add: endEvent.

	resultsValidSub := (AN01FlowNodeIncomingFlow validate: eventSubProcess withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: eventSubProcess withModel: model).
	self
		assert: resultsValidSub isEmpty
		description: 'Event subprocess (containing non-interrupting or Error/Escalation/Compensation start event) must not require incoming/outgoing sequence flows'.

	invalidSubProcess := OPBPMNSubProcessModel new name: 'Error Handler'.
	invalidErrorStart := OPBPMNStartEventModel new
		name: 'Invalid NI Error';
		type: OPBPMNNodeType Error;
		isNonInterrupting: true;
		yourself.
	invalidSubProcess add: invalidErrorStart.
	resultsInvalidStart := SE05Error validate: invalidErrorStart withModel: model.
	self
		deny: resultsInvalidStart isEmpty
		description: 'Error start event inside a subprocess must not be allowed to be non-interrupting in SE05'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testExclusiveGatewayWithLabeledOutgoingFlowsDoesNotTriggerGW07 [
	| gateway target1 target2 flow1 flow2 results |
	gateway := OPBPMNGatewayModel new name: 'Decision'.
	gateway type: OPBPMNNodeType Exclusive.
	target1 := OPBPMNActivityModel new.
	target2 := OPBPMNActivityModel new.
	flow1 := (OPBPMNFlowModel from: gateway to: target1) name: 'Yes'.
	flow2 := (OPBPMNFlowModel from: gateway to: target2) name: 'No'.
	gateway addFlow: flow1; addFlow: flow2.
	results := GW07LabeledOutgoingFlows validate: gateway withModel: model.
	self
		assert: results isEmpty
		description: 'Exclusive gateway with labeled outgoing flows must not trigger GW07 warning'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testExpandedSubProcessAndPoolsProcessValidationRules [
	| pool1 pool2 msgFlow startEvent endEvent emptySubProcess incompleteSubProcess innerTask flow1 flow2 resultsB2B resultsSubProcess emptyPoolModel emptyPoolResults |
	pool1 := OPBPMNPoolModel new name: 'Customer'.
	pool2 := OPBPMNPoolModel new name: 'Supplier'.
	msgFlow := (OPBPMNMessageFlowModel from: pool1 to: pool2) name: 'Order'; yourself.
	pool1 addFlow: msgFlow.
	pool2 addFlow: msgFlow.
	model add: pool1; add: pool2.
	resultsB2B := controller validateProcess: model.
	self
		assert: resultsB2B results isEmpty
		description: 'B2B collaboration of black-box pools connected by message flow must not trigger PR02 or PR07'.

	emptyPoolModel := OPBPMNModel new.
	pool1 := OPBPMNPoolModel new name: 'Empty Pool'.
	emptyPoolModel add: pool1.
	emptyPoolResults := controller validateProcess: emptyPoolModel.
	self
		assert: (emptyPoolResults hasErrors: pool1)
		description: 'Single unconfigured empty pool without message flows must attach PR02 error directly to the pool'.

	model := OPBPMNModel new.
	startEvent := OPBPMNStartEventModel new name: 'Start'.
	emptySubProcess := OPBPMNSubProcessModel new name: 'Empty Sub'.
	incompleteSubProcess := OPBPMNSubProcessModel new name: 'Incomplete Sub'.
	innerTask := OPBPMNActivityModel new name: 'Inner Task'.
	incompleteSubProcess add: innerTask.
	endEvent := OPBPMNEndEventModel new name: 'End'.
	flow1 := OPBPMNFlowModel from: startEvent to: emptySubProcess.
	flow2 := OPBPMNFlowModel from: emptySubProcess to: endEvent.
	startEvent addFlow: flow1.
	emptySubProcess addFlow: flow1; addFlow: flow2.
	endEvent addFlow: flow2.
	model add: startEvent; add: emptySubProcess; add: incompleteSubProcess; add: endEvent.

	resultsSubProcess := controller validate: model.
	self
		assert: (resultsSubProcess selectErrors anySatisfy: [ :each |
			each objectReference == emptySubProcess and: [ each messageText includesSubstring: 'PR02' ] ])
		description: 'Expanded subprocess without any inner activity must trigger PR02 error on the subprocess'.
	self
		assert: (resultsSubProcess selectWarnings anySatisfy: [ :each |
			each objectReference == incompleteSubProcess and: [ each messageText includesSubstring: 'PR07' ] ])
		description: 'Expanded subprocess without inner start and end events must trigger PR07 warning on the subprocess'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testGatewayWithAssociationDoesNotAffectGW02 [
	| gateway inTask outTask inFlow outFlow annotation association results |
	gateway := OPBPMNGatewayModel new name: 'Gateway'.
	inTask := OPBPMNActivityModel new.
	outTask := OPBPMNActivityModel new.
	inFlow := OPBPMNFlowModel from: inTask to: gateway.
	outFlow := OPBPMNFlowModel from: gateway to: outTask.
	gateway addFlow: inFlow; addFlow: outFlow.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: gateway.
	association target: annotation.
	gateway addAssociation: association.
	results := GW02Splitting validate: gateway withModel: model.
	self
		deny: results isEmpty
		description: 'Gateway with 1 incoming and 1 outgoing sequence flow plus 1 association must trigger GW02 error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testInterruptingTimerEventSubProcessDoesNotTriggerAN01OrAN02AndNormalSubProcessWithTypedStartTriggersSE06 [
	| eventSubProcess interruptingTimerStart innerTask endEvent f1 f2 normalSubProcess outerStart outerEnd invalidTypedStart fIn fOut resultsEventSub resultsNormalSub |
	eventSubProcess := OPBPMNSubProcessModel new name: 'Interrupting Timeout Handler'.
	interruptingTimerStart := OPBPMNStartEventModel new
		name: 'Timeout';
		type: OPBPMNNodeType Timer;
		isNonInterrupting: false;
		yourself.
	innerTask := OPBPMNActivityModel new name: 'Abort Order'.
	endEvent := OPBPMNEndEventModel new name: 'Aborted'.
	f1 := OPBPMNFlowModel from: interruptingTimerStart to: innerTask.
	f2 := OPBPMNFlowModel from: innerTask to: endEvent.
	interruptingTimerStart addFlow: f1.
	innerTask addFlow: f1; addFlow: f2.
	endEvent addFlow: f2.
	eventSubProcess add: interruptingTimerStart; add: innerTask; add: endEvent.
	model add: eventSubProcess.

	resultsEventSub := (AN01FlowNodeIncomingFlow validate: eventSubProcess withModel: model)
		, (AN02FlowNodeOutgoingFlow validate: eventSubProcess withModel: model).
	self
		assert: resultsEventSub isEmpty
		description: 'Interrupting Timer Event Sub-Process without incoming/outgoing sequence flows must not trigger AN01 or AN02'.

	outerStart := OPBPMNStartEventModel new name: 'Start'.
	normalSubProcess := OPBPMNSubProcessModel new name: 'Embedded SubProcess'.
	invalidTypedStart := OPBPMNStartEventModel new
		name: 'Invalid Timer In Embedded Sub';
		type: OPBPMNNodeType Timer;
		yourself.
	outerEnd := OPBPMNEndEventModel new name: 'End'.
	fIn := OPBPMNFlowModel from: outerStart to: normalSubProcess.
	fOut := OPBPMNFlowModel from: normalSubProcess to: outerEnd.
	outerStart addFlow: fIn.
	normalSubProcess addFlow: fIn; addFlow: fOut.
	outerEnd addFlow: fOut.
	normalSubProcess add: invalidTypedStart.
	model add: outerStart; add: normalSubProcess; add: outerEnd.

	resultsNormalSub := controller validate: model.
	self
		assert: (resultsNormalSub selectErrors anySatisfy: [ :each |
			each objectReference == invalidTypedStart and: [ each messageText includesSubstring: 'SE06' ] ])
		description: 'Typed Start Event inside a normal Embedded Sub-Process (connected to sequence flows) must trigger SE06 error'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testLinkEventsPairingValidationRuleIE05 [
	| throwLinkA catchLinkA orphanThrow duplicateCatch1 duplicateCatch2 throwDuplicate results |
	throwLinkA := OPBPMNIntermediateEventModel new
		name: 'GoToSectionA';
		type: OPBPMNNodeType LinkThrow;
		yourself.
	catchLinkA := OPBPMNIntermediateEventModel new
		name: 'GoToSectionA';
		type: OPBPMNNodeType Link;
		yourself.
	orphanThrow := OPBPMNIntermediateEventModel new
		name: 'MissingTarget';
		type: OPBPMNNodeType LinkThrow;
		yourself.
	throwDuplicate := OPBPMNIntermediateEventModel new
		name: 'AmbiguousLink';
		type: OPBPMNNodeType LinkThrow;
		yourself.
	duplicateCatch1 := OPBPMNIntermediateEventModel new
		name: 'AmbiguousLink';
		type: OPBPMNNodeType Link;
		yourself.
	duplicateCatch2 := OPBPMNIntermediateEventModel new
		name: 'AmbiguousLink';
		type: OPBPMNNodeType Link;
		yourself.
	model
		add: throwLinkA;
		add: catchLinkA;
		add: orphanThrow;
		add: throwDuplicate;
		add: duplicateCatch1;
		add: duplicateCatch2.

	results := controller validate: model.
	self
		deny: (results selectErrors anySatisfy: [ :each |
			(each objectReference == throwLinkA or: [ each objectReference == catchLinkA ])
				and: [ each messageText includesSubstring: 'IE05' ] ])
		description: 'Properly paired LinkThrow and Link catch events must not trigger IE05 error'.
	self
		assert: (results selectErrors anySatisfy: [ :each |
			each objectReference == orphanThrow and: [ each messageText includesSubstring: 'IE05' ] ])
		description: 'Unpaired LinkThrow event must trigger IE05 error'.
	self
		assert: (results selectErrors anySatisfy: [ :each |
			each objectReference == throwDuplicate and: [ each messageText includesSubstring: 'IE05' ] ])
		description: 'LinkThrow event with multiple matching Link catch events in the same scope must trigger IE05 error'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testManualTaskCanHaveIncomingAndOutgoingMessageFlowsWithoutAC03OrAC04Error [
	| manualTask blackBoxPool inMsg outMsg results |
	manualTask := OPBPMNActivityModel new
		name: 'Hand Over Signed Contract';
		type: OPBPMNNodeType Manual;
		yourself.
	blackBoxPool := OPBPMNPoolModel new name: 'Client'.
	inMsg := (OPBPMNMessageFlowModel from: blackBoxPool to: manualTask) name: 'Signed Copy'.
	outMsg := (OPBPMNMessageFlowModel from: manualTask to: blackBoxPool) name: 'Receipt'.
	manualTask addFlow: inMsg; addFlow: outMsg.

	results := (AC03MessageReceiveOther validate: manualTask withModel: model)
		, (AC04MessageSendOther validate: manualTask withModel: model).
	self
		assert: results isEmpty
		description: 'Manual task is allowed by BPMN 2.0.2 to send and receive message flows without triggering AC03 or AC04'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testMergingExclusiveGatewayAndEventBasedGatewayDoNotTriggerAN05Warning [
	| mergingExclusiveGateway eventBasedGateway in1 in2 out1 catch1 catch2 resultsMerging resultsEventBased |
	mergingExclusiveGateway := OPBPMNGatewayModel new
		name: '';
		type: OPBPMNNodeType Exclusive;
		yourself.
	in1 := OPBPMNActivityModel new name: 'In 1'.
	in2 := OPBPMNActivityModel new name: 'In 2'.
	out1 := OPBPMNActivityModel new name: 'Out 1'.
	mergingExclusiveGateway
		addFlow: (OPBPMNFlowModel from: in1 to: mergingExclusiveGateway);
		addFlow: (OPBPMNFlowModel from: in2 to: mergingExclusiveGateway);
		addFlow: (OPBPMNFlowModel from: mergingExclusiveGateway to: out1).

	eventBasedGateway := OPBPMNGatewayModel new
		name: '';
		type: OPBPMNNodeType Eventbased;
		yourself.
	catch1 := OPBPMNIntermediateEventModel new name: 'C1'; type: OPBPMNNodeType Timer; yourself.
	catch2 := OPBPMNIntermediateEventModel new name: 'C2'; type: OPBPMNNodeType Receive; yourself.
	eventBasedGateway
		addFlow: (OPBPMNFlowModel from: out1 to: eventBasedGateway);
		addFlow: (OPBPMNFlowModel from: eventBasedGateway to: catch1);
		addFlow: (OPBPMNFlowModel from: eventBasedGateway to: catch2).

	resultsMerging := AN05LabelValidation validate: mergingExclusiveGateway withModel: model.
	resultsEventBased := AN05LabelValidation validate: eventBasedGateway withModel: model.
	self
		assert: resultsMerging isEmpty
		description: 'Merging exclusive gateway must not require a label in AN05'.
	self
		assert: resultsEventBased isEmpty
		description: 'Event-based gateway must not require a label in AN05'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testMessageEndEventWithAssociationStillTriggersEE03WhenMissingMessageFlow [
	| endEvent annotation association results |
	endEvent := OPBPMNEndEventModel new name: 'Message End'.
	endEvent type: OPBPMNNodeType Send.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: endEvent.
	association target: annotation.
	endEvent addAssociation: association.
	results := EE03MessageSend validate: endEvent withModel: model.
	self
		deny: results isEmpty
		description: 'Message end event without outgoing message flow must trigger EE03 even when an association is connected'.
	self
		assert: results first severity
		equals: 'Warning'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testMessageFlowWithWhitespaceOrNilNameTriggersAN04Warning [
	| sendTask pool msgFlowWhitespace results |
	sendTask := OPBPMNActivityModel new
		name: 'Send Task';
		type: OPBPMNNodeType Send;
		yourself.
	pool := OPBPMNPoolModel new name: 'Partner'.
	msgFlowWhitespace := (OPBPMNMessageFlowModel from: sendTask to: pool)
		name: '   ';
		yourself.
	sendTask addFlow: msgFlowWhitespace.
	results := AN04LabeledMessageFlow validate: sendTask withModel: model.
	self
		deny: results isEmpty
		description: 'Message flow with whitespace-only name must trigger AN04 warning'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testMessageStartEventWithAssociationStillTriggersSE03WhenMissingMessageFlow [
	| startEvent annotation association results |
	startEvent := OPBPMNStartEventModel new name: 'Message Start'.
	startEvent type: OPBPMNNodeType Receive.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: annotation.
	association target: startEvent.
	startEvent addAssociation: association.
	results := SE03MessageReceive validate: startEvent withModel: model.
	self
		deny: results isEmpty
		description: 'Message start event without incoming message flow must trigger SE03 even when an association is connected'.
	self
		assert: results first severity
		equals: 'Warning'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testMultipleThrowAndParallelMultipleEventsMessageFlowValidationRules [
	| pool multipleThrowIE multipleCatchIE parallelMultipleIE parallelMultipleSE resultsThrowValid resultsCatchInvalid resultsParallelIE resultsParallelSE |
	pool := OPBPMNPoolModel new name: 'External'.
	multipleThrowIE := OPBPMNIntermediateEventModel new
		name: 'Throw Mult';
		type: OPBPMNNodeType MultipleThrow;
		yourself.
	multipleThrowIE addFlow: (OPBPMNMessageFlowModel from: multipleThrowIE to: pool).

	multipleCatchIE := OPBPMNIntermediateEventModel new
		name: 'Catch Mult';
		type: OPBPMNNodeType Multiple;
		yourself.
	multipleCatchIE addFlow: (OPBPMNMessageFlowModel from: multipleCatchIE to: pool).

	parallelMultipleIE := OPBPMNIntermediateEventModel new
		name: 'Catch ParMult';
		type: OPBPMNNodeType ParallelMultiple;
		yourself.
	parallelMultipleIE addFlow: (OPBPMNMessageFlowModel from: pool to: parallelMultipleIE).

	parallelMultipleSE := OPBPMNStartEventModel new
		name: 'Start ParMult';
		type: OPBPMNNodeType ParallelMultiple;
		yourself.
	parallelMultipleSE addFlow: (OPBPMNMessageFlowModel from: pool to: parallelMultipleSE).

	resultsThrowValid := IE04MessageSendOther validate: multipleThrowIE withModel: model.
	resultsCatchInvalid := IE04MessageSendOther validate: multipleCatchIE withModel: model.
	resultsParallelIE := IE03MessageReceiveOther validate: parallelMultipleIE withModel: model.
	resultsParallelSE := SE04MessageOther validate: parallelMultipleSE withModel: model.

	self
		assert: resultsThrowValid isEmpty
		description: 'MultipleThrow intermediate event must be allowed to have outgoing message flow in IE04'.
	self
		deny: resultsCatchInvalid isEmpty
		description: 'Catching Multiple intermediate event must not be allowed to have outgoing message flow in IE04'.
	self
		assert: resultsParallelIE isEmpty
		description: 'ParallelMultiple intermediate event must be allowed to have incoming message flow in IE03'.
	self
		assert: resultsParallelSE isEmpty
		description: 'ParallelMultiple start event must be allowed to have incoming message flow in SE04'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testNodeWithMultipleConditionalFlowsAndNoDefaultFlowTriggersAN06Error [
	| task target1 target2 condFlow1 condFlow2 results |
	task := OPBPMNActivityModel new name: 'Task'.
	target1 := OPBPMNActivityModel new name: 'T1'.
	target2 := OPBPMNActivityModel new name: 'T2'.
	condFlow1 := (OPBPMNFlowModel from: task to: target1) type: 'Conditional'; yourself.
	condFlow2 := (OPBPMNFlowModel from: task to: target2) type: 'Conditional'; yourself.
	task addFlow: condFlow1; addFlow: condFlow2.
	results := AN06OnlyConditionalFlow validate: task withModel: model.
	self
		deny: results isEmpty
		description: 'Node having multiple outgoing flows that are all Conditional without a Default flow must trigger AN06'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testNonInterruptingCancelOrCompensationBoundaryEventTriggersBE05Error [
	| cancelBoundary compBoundary cancelResults compResults |
	cancelBoundary := OPBPMNBoundaryEventModel new
		name: 'Cancel';
		type: OPBPMNNodeType Cancel;
		isNonInterrupting: true;
		yourself.
	compBoundary := OPBPMNBoundaryEventModel new
		name: 'Comp';
		type: OPBPMNNodeType CatchCompensation;
		isNonInterrupting: true;
		yourself.
	cancelResults := BE05ErrorNonInterrupting validate: cancelBoundary withModel: model.
	compResults := BE05ErrorNonInterrupting validate: compBoundary withModel: model.
	self
		deny: cancelResults isEmpty
		description: 'Non-interrupting Cancel boundary event must trigger BE05 error'.
	self
		deny: compResults isEmpty
		description: 'Non-interrupting Compensation boundary event must trigger BE05 error'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testPR04AllInsidePoolTriggeredWhenActivityIsOutsidePool [
	| pool taskInPool taskOutside results |
	pool := OPBPMNPoolModel new name: 'Pool'.
	taskInPool := OPBPMNActivityModel new name: 'Task In Pool'.
	pool add: taskInPool.
	taskOutside := OPBPMNActivityModel new name: 'Task Outside'.
	model add: pool; add: taskOutside.
	results := controller validate: model.
	self
		assert: (results selectWarnings anySatisfy: [ :each | each messageText includesSubstring: 'PR04' ])
		description: 'Activity outside pool when pool is present must produce PR04 warning'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testPR04TriggeredWhenStartEventOrDataObjectIsOutsidePool [
	| pool startInPool taskInPool endInPool orphanDataObject results |
	pool := OPBPMNPoolModel new name: 'Main Pool'.
	startInPool := OPBPMNStartEventModel new name: 'Start'.
	taskInPool := OPBPMNActivityModel new name: 'Task'.
	endInPool := OPBPMNEndEventModel new name: 'End'.
	pool add: startInPool; add: taskInPool; add: endInPool.
	orphanDataObject := OPBPMNDataObjectModel new name: 'Orphan Data'.
	model add: pool; add: orphanDataObject.
	results := controller validate: model.
	self
		assert: (results selectWarnings anySatisfy: [ :each | each messageText includesSubstring: 'PR04' ])
		description: 'Data object or flow node outside pool when pool is present must trigger PR04 warning'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testPR07WarnsWhenProcessMissingEndEvent [
	| startEvent task results |
	startEvent := OPBPMNStartEventModel new name: 'Start'.
	task := OPBPMNActivityModel new name: 'Task'.
	model add: startEvent; add: task.
	results := controller validate: model.
	self
		assert: (results selectWarnings anySatisfy: [ :each | each messageText includesSubstring: 'PR07' ])
		description: 'Process without end event must trigger PR07 warning'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testParallelAndEventBasedGatewayAllowLabeledNormalOutgoingFlowsInGW05 [
	| parallelGateway target1 target2 flow1 flow2 results |
	parallelGateway := OPBPMNGatewayModel new
		name: 'Parallel Split';
		type: OPBPMNNodeType Parallel;
		yourself.
	target1 := OPBPMNActivityModel new name: 'Branch A'.
	target2 := OPBPMNActivityModel new name: 'Branch B'.
	flow1 := (OPBPMNFlowModel from: parallelGateway to: target1)
		name: 'Track 1';
		type: 'Normal';
		yourself.
	flow2 := (OPBPMNFlowModel from: parallelGateway to: target2)
		name: 'Track 2';
		type: 'Normal';
		yourself.
	parallelGateway addFlow: flow1; addFlow: flow2.

	results := GW05ParallelEventGatewayOutgoingFlows validate: parallelGateway withModel: model.
	self
		assert: results isEmpty
		description: 'Labeled normal outgoing sequence flows from a Parallel Gateway are valid in BPMN 2.0.2 and must not trigger GW05'
]

{ #category : 'tests - gateways' }
OPBPMNValidationComprehensiveRulesTest >> testParallelGatewayWithDefaultOutgoingFlowTriggersGW05AndNilNameDoesNotTriggerGW05 [
	| parallelWithNilName parallelWithDefault t1 t2 flowNil1 flowNil2 flowDefault flowNormal resultsNilName resultsDefault |
	parallelWithNilName := OPBPMNGatewayModel new
		name: 'Parallel Clean';
		type: OPBPMNNodeType Parallel;
		yourself.
	t1 := OPBPMNActivityModel new name: 'T1'.
	t2 := OPBPMNActivityModel new name: 'T2'.
	flowNil1 := (OPBPMNFlowModel from: parallelWithNilName to: t1) name: nil; yourself.
	flowNil2 := (OPBPMNFlowModel from: parallelWithNilName to: t2) name: ''; yourself.
	parallelWithNilName addFlow: flowNil1; addFlow: flowNil2.

	parallelWithDefault := OPBPMNGatewayModel new
		name: 'Parallel Default';
		type: OPBPMNNodeType Parallel;
		yourself.
	flowDefault := (OPBPMNFlowModel from: parallelWithDefault to: t1) type: 'Default'; yourself.
	flowNormal := (OPBPMNFlowModel from: parallelWithDefault to: t2) type: 'Normal'; yourself.
	parallelWithDefault addFlow: flowDefault; addFlow: flowNormal.

	resultsNilName := GW05ParallelEventGatewayOutgoingFlows validate: parallelWithNilName withModel: model.
	resultsDefault := GW05ParallelEventGatewayOutgoingFlows validate: parallelWithDefault withModel: model.
	self
		assert: resultsNilName isEmpty
		description: 'Unlabeled sequence flow with nil name on Parallel gateway must not trigger GW05'.
	self
		deny: resultsDefault isEmpty
		description: 'Default sequence flow on Parallel gateway must trigger GW05 error'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testPoolMissingTopLevelStartAndEndEventsTriggersPR07EvenWhenSubProcessHasThem [
	| pool subProcess innerStart innerTask innerEnd results |
	pool := OPBPMNPoolModel new name: 'Main Pool'.
	subProcess := OPBPMNSubProcessModel new name: 'SubProcess'.
	innerStart := OPBPMNStartEventModel new name: 'Inner Start'.
	innerTask := OPBPMNActivityModel new name: 'Inner Task'.
	innerEnd := OPBPMNEndEventModel new name: 'Inner End'.
	subProcess add: innerStart; add: innerTask; add: innerEnd.
	pool add: subProcess.
	model add: pool.
	results := controller validate: model.
	self
		assert: (results selectWarnings anySatisfy: [ :each | each messageText includesSubstring: 'PR07' ])
		description: 'Pool without top-level start and end events must trigger PR07 even if an inner subprocess has start and end events'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testServiceAndUserTasksCanHaveIncomingAndOutgoingMessageFlowsWithoutAC03OrAC04Error [
	| serviceTask userTask blackBoxPool inMsg1 outMsg1 inMsg2 outMsg2 results |
	serviceTask := OPBPMNActivityModel new
		name: 'Service Task';
		type: OPBPMNNodeType Service;
		yourself.
	userTask := OPBPMNActivityModel new
		name: 'User Task';
		type: OPBPMNNodeType User;
		yourself.
	blackBoxPool := OPBPMNPoolModel new name: 'External Partner'.
	inMsg1 := (OPBPMNMessageFlowModel from: blackBoxPool to: serviceTask) name: 'Req 1'.
	outMsg1 := (OPBPMNMessageFlowModel from: serviceTask to: blackBoxPool) name: 'Resp 1'.
	serviceTask addFlow: inMsg1; addFlow: outMsg1.
	inMsg2 := (OPBPMNMessageFlowModel from: blackBoxPool to: userTask) name: 'Req 2'.
	outMsg2 := (OPBPMNMessageFlowModel from: userTask to: blackBoxPool) name: 'Resp 2'.
	userTask addFlow: inMsg2; addFlow: outMsg2.

	results := (AC03MessageReceiveOther validate: serviceTask withModel: model)
		, (AC04MessageSendOther validate: serviceTask withModel: model)
		, (AC03MessageReceiveOther validate: userTask withModel: model)
		, (AC04MessageSendOther validate: userTask withModel: model).
	self
		assert: results isEmpty
		description: 'Service and User tasks are allowed by BPMN 2.0 to send and receive message flows without triggering AC03 or AC04'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testStartEventOrParallelGatewayCannotHaveDefaultOutgoingSequenceFlow [
	| startEvent parallelGateway target1 target2 startDefaultFlow startNormalFlow gwDefaultFlow gwNormalFlow startResults gwResults |
	startEvent := OPBPMNStartEventModel new name: 'Start'.
	parallelGateway := OPBPMNGatewayModel new
		name: 'Parallel Split';
		type: OPBPMNNodeType Parallel;
		yourself.
	target1 := OPBPMNActivityModel new name: 'T1'.
	target2 := OPBPMNActivityModel new name: 'T2'.
	startDefaultFlow := (OPBPMNFlowModel from: startEvent to: target1) type: 'Default'; yourself.
	startNormalFlow := (OPBPMNFlowModel from: startEvent to: target2) type: 'Normal'; yourself.
	startEvent addFlow: startDefaultFlow; addFlow: startNormalFlow.

	gwDefaultFlow := (OPBPMNFlowModel from: parallelGateway to: target1) type: 'Default'; yourself.
	gwNormalFlow := (OPBPMNFlowModel from: parallelGateway to: target2) type: 'Normal'; yourself.
	parallelGateway addFlow: gwDefaultFlow; addFlow: gwNormalFlow.

	startResults := AN03MaxOneDefaultFlow validate: startEvent withModel: model.
	gwResults := AN03MaxOneDefaultFlow validate: parallelGateway withModel: model.
	self
		deny: startResults isEmpty
		description: 'Start event must not be allowed to have a Default sequence flow'.
	self
		deny: gwResults isEmpty
		description: 'Parallel gateway must not be allowed to have a Default sequence flow'
]

{ #category : 'tests - events' }
OPBPMNValidationComprehensiveRulesTest >> testStartEventWithAssociationDoesNotTriggerSE04 [
	| startEvent annotation association results |
	startEvent := OPBPMNStartEventModel new name: 'Start'.
	startEvent type: OPBPMNNodeType None.
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: annotation.
	association target: startEvent.
	startEvent addAssociation: association.
	results := SE04MessageOther validate: startEvent withModel: model.
	self
		assert: results isEmpty
		description: 'Start event connected to annotation via association must not trigger SE04 error'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testSubProcessWithMultipleIncomingOrOutgoingSequenceFlowsTriggersAC05Warning [
	| subProcess collapsedSubProcess s1 s2 t1 t2 resultsSub resultsCollapsed |
	subProcess := OPBPMNSubProcessModel new name: 'Expanded SubProcess'.
	collapsedSubProcess := OPBPMNCollapsedSubProcessModel new name: 'Collapsed SubProcess'.
	s1 := OPBPMNStartEventModel new.
	s2 := OPBPMNStartEventModel new.
	t1 := OPBPMNEndEventModel new.
	t2 := OPBPMNEndEventModel new.
	subProcess
		addFlow: (OPBPMNFlowModel from: s1 to: subProcess);
		addFlow: (OPBPMNFlowModel from: s2 to: subProcess).
	collapsedSubProcess
		addFlow: (OPBPMNFlowModel from: collapsedSubProcess to: t1);
		addFlow: (OPBPMNFlowModel from: collapsedSubProcess to: t2).

	resultsSub := AC05ActivityMergingFlows validate: subProcess withModel: model.
	resultsCollapsed := AC05ActivityMergingFlows validate: collapsedSubProcess withModel: model.
	self
		deny: resultsSub isEmpty
		description: 'Expanded subprocess with multiple incoming sequence flows must trigger AC05 warning'.
	self
		deny: resultsCollapsed isEmpty
		description: 'Collapsed subprocess with multiple outgoing sequence flows must trigger AC05 warning'
]

{ #category : 'tests - activities' }
OPBPMNValidationComprehensiveRulesTest >> testUnconnectedDataObjectAndAnnotationTriggerAN07Warning [
	| connectedData unconnectedData connectedAnnotation unconnectedAnnotation task dataFlow assoc results |
	task := OPBPMNActivityModel new name: 'Process Task'.
	connectedData := OPBPMNDataObjectModel new name: 'Connected Data'.
	unconnectedData := OPBPMNDataObjectModel new name: 'Orphan Data'.
	connectedAnnotation := OPBPMNAnnotationModel new text: 'Connected Note'.
	unconnectedAnnotation := OPBPMNAnnotationModel new text: 'Orphan Note'.
	dataFlow := OPBPMNDataFlowModel from: connectedData to: task.
	connectedData addFlow: dataFlow.
	task addFlow: dataFlow.
	assoc := OPBPMNAssociationModel new
		source: connectedAnnotation;
		target: task;
		yourself.
	connectedAnnotation addAssociation: assoc.
	task addAssociation: assoc.
	model
		add: task;
		add: connectedData;
		add: unconnectedData;
		add: connectedAnnotation;
		add: unconnectedAnnotation.

	results := controller validate: model.
	self
		deny: (results selectWarnings anySatisfy: [ :each |
			(each objectReference == connectedData or: [ each objectReference == connectedAnnotation ])
				and: [ each messageText includesSubstring: 'AN07' ] ])
		description: 'Connected DataObject and Annotation must not trigger AN07 warning'.
	self
		assert: (results selectWarnings anySatisfy: [ :each |
			each objectReference == unconnectedData and: [ each messageText includesSubstring: 'AN07' ] ])
		description: 'Unconnected DataObject must trigger AN07 warning'.
	self
		assert: (results selectWarnings anySatisfy: [ :each |
			each objectReference == unconnectedAnnotation and: [ each messageText includesSubstring: 'AN07' ] ])
		description: 'Unconnected Annotation must trigger AN07 warning'
]

{ #category : 'tests - ui' }
OPBPMNValidationComprehensiveRulesTest >> testValidationResultsUIHighlightModelAndFlowDoesNotCrash [
	| project projectController diagramController task1 task2 flow results resultsUI |
	project := OPProject new.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself);
		diagramElement: (OPOpenPonkDiagram forModelElement: model);
		model: model.
	task1 := OPBPMNActivityModel new name: 'T1'.
	task2 := OPBPMNActivityModel new name: 'T2'.
	flow := OPBPMNFlowModel from: task1 to: task2.
	task1 addFlow: flow.
	task2 addFlow: flow.
	model add: task1; add: task2.
	diagramController showAllElements.
	results := controller validate: model.
	resultsUI := OPBPMNValidationResultsUI createUIFor: results withControllers: diagramController.
	resultsUI highlightElement: model.
	resultsUI highlightElement: flow.
	resultsUI highlightElement: task1.
	self assert: resultsUI highlighted equals: task1
]

{ #category : 'tests - ui' }
OPBPMNValidationComprehensiveRulesTest >> testValidationUIHighlightsPoolWithErrors [
	| project projectController diagramController pool poolController results |
	project := OPProject new.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself);
		diagramElement: (OPOpenPonkDiagram forModelElement: model);
		model: model.
	pool := OPBPMNPoolModel new name: 'Invalid WhiteBox'.
	pool add: (OPBPMNActivityModel new name: 'Task').
	pool addFlow: (OPBPMNMessageFlowModel from: pool to: (OPBPMNPoolModel new name: 'Other')).
	model add: pool.
	diagramController showAllElements.
	poolController := diagramController controllerForModel: pool.
	results := controller validate: model.
	OPBPMNValidationUI updateValidatedElementStyle: results using: poolController.
	self
		assert: poolController diagramElement borderColor
		equals: Color red
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testWhiteBoxPoolMissingActivityTriggersPR02EvenWhenAnotherPoolHasActivity [
	| completePool emptyProcessPool start1 task1 end1 start2 end2 results |
	completePool := OPBPMNPoolModel new name: 'Complete Pool'.
	start1 := OPBPMNStartEventModel new name: 'Start 1'.
	task1 := OPBPMNActivityModel new name: 'Task 1'.
	end1 := OPBPMNEndEventModel new name: 'End 1'.
	completePool add: start1; add: task1; add: end1.

	emptyProcessPool := OPBPMNPoolModel new name: 'Pool Without Activity'.
	start2 := OPBPMNStartEventModel new name: 'Start 2'.
	end2 := OPBPMNEndEventModel new name: 'End 2'.
	emptyProcessPool add: start2; add: end2.

	model add: completePool; add: emptyProcessPool.
	results := controller validate: model.
	self
		assert: (results selectErrors anySatisfy: [ :each |
			(each messageText includesSubstring: 'PR02') and: [
				each objectReference == emptyProcessPool or: [ each objectReference == model ] ] ])
		description: 'White-box pool without any activity must trigger PR02 error even when another pool has an activity'
]

{ #category : 'tests - process' }
OPBPMNValidationComprehensiveRulesTest >> testWhiteBoxPoolMissingStartOrEndEventTriggersPR07EvenWhenAnotherPoolIsComplete [
	| completePool incompletePool start1 task1 end1 task2 results |
	completePool := OPBPMNPoolModel new name: 'Complete Pool'.
	start1 := OPBPMNStartEventModel new name: 'Start 1'.
	task1 := OPBPMNActivityModel new name: 'Task 1'.
	end1 := OPBPMNEndEventModel new name: 'End 1'.
	completePool add: start1; add: task1; add: end1.

	incompletePool := OPBPMNPoolModel new name: 'Incomplete Pool'.
	task2 := OPBPMNActivityModel new name: 'Task 2'.
	incompletePool add: task2.

	model add: completePool; add: incompletePool.
	results := controller validate: model.
	self
		assert: (results selectWarnings anySatisfy: [ :each |
			(each messageText includesSubstring: 'PR07') and: [
				each objectReference == incompletePool or: [ each objectReference == model ] ] ])
		description: 'White-box pool missing start and end events must trigger PR07 warning even when another pool has them'
]

{ #category : 'tests - pools' }
OPBPMNValidationComprehensiveRulesTest >> testWhiteBoxPoolWithAssociationDoesNotTriggerPR05 [
	| pool annotation association results |
	pool := OPBPMNPoolModel new name: 'Pool'.
	pool add: (OPBPMNActivityModel new name: 'Task').
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: annotation.
	association target: pool.
	pool addAssociation: association.
	results := PR05BlackBoxIncomingMessage validate: pool withModel: model.
	self
		assert: results isEmpty
		description: 'White-box pool with incoming association must not trigger PR05 message flow error'
]

{ #category : 'tests - pools' }
OPBPMNValidationComprehensiveRulesTest >> testWhiteBoxPoolWithAssociationDoesNotTriggerPR06 [
	| pool annotation association results |
	pool := OPBPMNPoolModel new name: 'Pool'.
	pool add: (OPBPMNActivityModel new name: 'Task').
	annotation := OPBPMNAnnotationModel new text: 'Note'.
	association := OPBPMNAssociationModel new.
	association source: pool.
	association target: annotation.
	pool addAssociation: association.
	results := PR06BlackBoxOutgoingMessage validate: pool withModel: model.
	self
		assert: results isEmpty
		description: 'White-box pool with outgoing association must not trigger PR06 message flow error'
]
