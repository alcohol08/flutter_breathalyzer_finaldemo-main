import 'package:flutter/material.dart';

class Learn {
  late String title;
  late String author;
  late String description;
  late String imageUrl;

  Learn(
  {required this.title,
    required this.author,
    required this.description,
    required this.imageUrl});
}

List<Learn> learnList= [
  Learn(
    title: 'Treating Alcohol Use Disorder',
    author: 'Harvard Medical School',
    description:
      'As with many other chronic diseases, AUD treatment is not as straightforward as taking antibiotics for pneumonia. However, it may surprise you that there are several medications that can help patients deal with cravings and reduce drinking. Naltrexone, acamprosate, and disulfiram are among the current FDA-approved drugs to treat AUD.'+ '\n\n' +
       'Other drugs that are used off-label to treat AUD include nalmefene, baclofen, gabapentin, and topiramate. Individual and group therapy may also help reduce binge drinking and increase abstinence.'+ '\n\n' +
       'Nonetheless, it may be hard to keep the motivation going. Relapses are a common part of the disease, and successfully overcoming AUD often depends on stability at work, adequate housing, hope for the future, and support from family, friends, and the health system. Don’t be afraid to seek professional help if alcohol use defines who you are and is affecting your life and relationships. We now have several approaches that may lead to healing and recovery. A simple conversation with your doctor about whether or not you have a problem with alcohol use could be the first step toward a healthier and more fulfilling life.',
      imageUrl: 'https://domf5oio6qrcr.cloudfront.net/medialibrary/9651/iStock-136256452.jpg'),
  Learn(
    title: 'Understanding and Recognizing Alcohol Abuse',
    author: 'Main Line Health',
    description:
          'When you find yourself over indulging or drinking more frequently than you should, and you begin to experience minor consequences as a result you may be abusing alcohol.'+ '\n\n' +
              'While individuals who experience alcohol abuse typically don’t experience withdrawal symptoms even if engage in daily drinking, they will often experience unmanageability and their daily responsibilities or habits can take a backseat to drinking. Behaviors like oversleeping, repeatedly arriving late to work, forgetting plans with friends, becoming more argumentative with a spouse or partner or not taking care of yourself or your hygiene are all signs that alcohol is making it difficult to manage everyday life. This creates an ongoing cycle of increased stress and dysfunction.'+ '\n\n' +
                  '"Many people turn to alcohol to cope with these feelings of stress, fatigue or disorganization. Drinking becomes a primary coping method and, rather than finding healthy ways to cope with these feelings, alcohol abuse can progress into alcohol dependency,” explains Cirillo.',
    imageUrl: 'https://healingproperties.org/wp-content/uploads/2021/01/alcohol-use-disorder-scaled.jpg'),
  Learn(
    title: 'How Alcohol Abuse Can Affect Romantic Relationships',
    author: 'Discovery Mood & Anxiety Program',
    description:
       'Alcohol abuse disorder significantly alters an individual’s personality, and as a result, it can make them unrecognizable from the person they were before they started drinking. '+ '\n\n' +
           'Individuals who have alcohol use disorder become more and more secretive, often out of fear, shame, or guilt. They begin to hide things from their significant other such as where they are, whom they are spending time with, and what they did during the day. Keeping the truth from your significant other may start as an innocent defense mechanism, but eventually, it will most likely lead to blatant lies and mistrust. '+ '\n\n' +
               'As the alcohol abuse progresses, the lies an individual tells to cover their addiction become more elaborate over time. For their loved one, it can feel as if all they are hearing is excuse after excuse, for being late, for disappearing, for the mood swings, for the missing money, for the hidden bottles in the bathroom. Trust is essential to a healthy and functioning relationship, and once it is damaged, it can be difficult to repair. It can often lead to feelings of fear and jealousy. Because proper communication is impossible without honesty, both people could begin feeling alone and isolated, increasing feelings of sadness and resentment.',
    imageUrl:'https://3nih9o367186ft57b1fkswsq-wpengine.netdna-ssl.com/wp-content/uploads/2018/09/iStock-669740900-510x340.jpg' ),
  Learn(
    title:'11 Ways to Curb Your Drinking',
    author:'Harvard Medical School',
    description:
      'Are you concerned about your alcohol intake? Maybe you feel that you are drinking too much or too often. Perhaps it is a habit you would like to better control.'+ '\n\n' +
      'Many people may benefit simply by cutting back. If your doctor suggests that you curb your drinking, the National Institute on Alcohol Abuse and Alcoholism (NIAAA) suggests that the following steps may be helpful:'+ '\n\n' +
      '1. Put it in writing. Making a list of the reasons to curtail your drinking — such as feeling healthier, sleeping better, or improving your relationships — can motivate you.'+ '\n\n' +
      '2. Do not keep alcohol in your house. Having no alcohol at home can help limit your drinking.'+ '\n\n' +
      '3. Keep busy. Take a walk, play sports, go out to eat, or catch a movie. When you are at home, pick up a new hobby or revisit an old one. Painting, board games, playing a musical instrument, woodworking — these and other activities are great alternatives to drinking.'+ '\n\n' +
      '4. Ask for support. Cutting down on your drinking may not always be easy. Let friends and family members know that you need their support. Your doctor, counselor, or therapist may also be able to offer help.'+ '\n\n' +
      '5. Guard against temptation. Steer clear of people and places that make you want to drink. If you associate drinking with certain events, such as holidays or vacations, develop a plan for managing them in advance. Monitor your feelings. When you are worried, lonely, or angry, you may be tempted to reach for a drink. Try to cultivate new, healthy ways to cope with stress.'+ '\n\n' +
      '6. Be persistent. Most people who successfully cut down or stop drinking altogether do so only after several attempts. You will probably have setbacks, but do not let them keep you from reaching your long-term goal. There is really no final endpoint, as the process usually requires ongoing effort.',
      imageUrl:'https://www.rehabguide.co.uk/wp-content/uploads/2018/06/I-want-to-stop-drinking157.jpg'),
  Learn(
    title:'The Disease Model of Alcoholism',
    author:'Soberlink',
    description:'The disease model of Alcoholism can be a controversial topic because of the perception and stigma attached to the word “disease.” The fact remains that alcoholism is a chronic, lifelong condition that must be monitored and managed. There are, like most diseases, behavioral, environmental, and genetic factors that contribute to alcoholism. Alcoholics have a physical and psychological need for alcohol throughout their addiction and many even report being addicted immediately after their first drink. Alcoholism is a progressive and degenerative disease that most people need help to fight against.'+ '\n\n'+
      'There are undeniable commonalities between alcoholism and other chronic conditions that further reinforce the disease model. Alcoholism has a genetic component and has been shown to run in families. In fact, studies at the National Institutes of Health claim alcoholism is 50% genetic. The same can be said for a condition like heart disease, some people are genetically predisposed to factors that increase their risk.'+ '\n\n' +
      'The Mayo Clinic website states that “Alcoholism is a chronic and often progressive disease that includes problems controlling your drinking, being preoccupied with alcohol, and continuing to use alcohol even when it causes problems.” Alcoholism results in physical and chemical changes in the brain. Prolonged alcohol abuse and a lack of continued-care will lead to serious health complications and an increased risk for certain cancers.',
imageUrl: 'https://assets.website-files.com/5f971992bc93849be0ba4e0d/5f976d37faabd30bd4146d4b_iStock_000036211058_alcoholism-wpv_870x350_center_center.jpg'),
  Learn(
    title:'The Link Between Stress and Alcoholism',
    author:'Carrier Clinic',
    description:'Some stress is normal and it is not always associated with something negative (i.e. getting married can be a stressful event, but it is also a happy, celebratory moment in a person’s life). However, if you are feeling stressed all the time and your stress is significantly affecting your emotional well-being, causing physical symptoms, impacting your ability to carry out your responsibilities, and/or you have started harmful habits such as self-medicating with drugs or alcohol to cope, then you need to seek help.'+ '\n\n'+
      'Drinking to cope with stress can, in particular, be a problem for teens. Some may see alcohol as a means of managing the daily and ever-increasing pressures of performing well in school, living up to societal and parental expectations, and gaining validation from their peers. Alcohol can also be seen as a means of escape from stressful situations at home.'+ '\n\n' +
      'In addition, the adolescent years can be a very stressful time when teens are looking to find acceptance and sometimes that means drinking to fit in. Because alcohol decreases inhibitions, it gives young people the confidence they feel they need to gain a sense of social belonging. Once this becomes a habit for dealing with uncomfortable or unknown situations, it can lead to problem drinking long-term.'+ '\n\n' +
      'According to a report on the Link Between Stress and Alcohol by the National Institute on Alcohol Abuse and Alcoholism (NIAAA), people with certain personality characteristics (impulsivity, novelty seeking, negative emotionality, and anxiety) are more prone to using alcohol to cope with stress. Additionally, a family history of alcoholism, having a mother who drank during pregnancy, traumatic childhood events, and/or having a pre-existing mental illness also increase your risk factor.',
imageUrl: 'https://carrierclinic.org/wp-content/uploads/2018/04/cc-stress-alcoholism-680x425.jpg'),
  Learn(
    title:'Alcohol and Anger: Causes, Dangers, How to Help',
    author:'Smarmore Castle',
    description:'Emotional instability should not be ignored as it can lead to many problems in life, and often pushes one towards alcohol and substance abuse. However, if a person is already dependent on alcohol, they will need to address that first.'+ '\n\n' +
        'When treating alcohol abuse or addiction, all the underlying issues need to be treated as well. Taking away the alcohol won’t resolve any issues with anger. Anger is one of the biggest causes of relapse, according to Alcoholics Anonymous. If it’s ignored, a person is likely to go back to their old ways, and increases the chance of relapse. Because of this, a rehab programme should include appropriate anger-management therapy as well as addiction treatment.'+ '\n\n' +
        'With alcohol or without, anger needs to be addressed. A person should be able to express and deal with their emotions in a proper manner. Hence, it is important for everyone to learn anger management skills. Dealing with your anger when you’re sober will help you avoid going into a rage when you’re drinking.',
        imageUrl: 'https://smarmore-rehab-clinic.com/wp-content/uploads/2020/03/Alcohol20and20anger.jpg'),

];