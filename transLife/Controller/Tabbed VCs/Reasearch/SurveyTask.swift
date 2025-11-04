//
//  SurveyTask.swift
//  SampleResearchKit
//
//  Created by Simon Ng on 3/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//
//
//import Foundation
//import ResearchKit
//
//public var SurveyTask: ORKOrderedTask {
//    
//    var steps = [ORKStep]()
//    
//    //Introduction
//    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "Survey no. 1"
//    instructionStep.text = "Answer all questions to complete the survey."
//    steps += [instructionStep]
//    
//    //Text Input Question
//    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
//    
//    nameAnswerFormat.multipleLines = false
//    let nameQuestionStepTitle = "Do you currently live full-time in a gender that is different from the one assigned to you at birth? "
//    let nameQuestionStep = ORKQuestionStep(identifier: "NameStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
//    nameQuestionStep.answerFormat = ORKBooleanAnswerFormat()
//    steps += [nameQuestionStep]
//    
//    //
//    let nameQuestionStepTitle1 = "How old were you when you started to live full-time in a gender that is different from the one assigned to you at birth? "
//    let ageQuestion = "How old are you?"
//    let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
//    ageAnswer.minimum = 18
//    ageAnswer.maximum = 85
//    let ageQuestionStep = ORKQuestionStep(identifier: "AgeStep", title: nameQuestionStepTitle1, answer: ageAnswer)
//    steps += [ageQuestionStep]
//    
//    //Image Input Question
//    let moodQuestion = "How do you feel today?"
//    let moodImages = [
//        (UIImage(named: "Happy")!, "Happy"),
//        (UIImage(named: "Angry")!, "Angry"),
//        (UIImage(named: "Sad")!, "Sad"),
//        ]
//    let moodChoice : [ORKImageChoice] = moodImages.map {
//        return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSCoding & NSCopying & NSObjectProtocol)
//    }
//    let answerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: moodChoice)
//    let moodQuestionStep = ORKQuestionStep(identifier: "MoodStep", title: moodQuestion, answer: answerFormat)
//    steps += [moodQuestionStep]
//    
//    //Numeric Input Question
////    let ageQuestion = "How old are you?"
////    let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
////    ageAnswer.minimum = 18
////    ageAnswer.maximum = 85
////    let ageQuestionStep = ORKQuestionStep(identifier: "AgeStep", title: ageQuestion, answer: ageAnswer)
////    steps += [ageQuestionStep]
//    
//    //Summary
//    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
//    completionStep.title = "Thank You!!"
//    completionStep.text = "You have completed the survey"
//    steps += [completionStep]
//    
//    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
//}
