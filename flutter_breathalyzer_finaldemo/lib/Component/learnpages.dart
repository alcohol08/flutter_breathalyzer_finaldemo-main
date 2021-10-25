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
      'Drinking in moderation is seen as a harmless activity, such as celebrating a special event or enjoying vacation with friends. In reality there is no level of alcohol use that can be considered completely risk free. When you find yourself over indulging or drinking more frequently than you should, and you begin to experience minor consequences as a result you may be abusing alcohol.While individuals who experience alcohol abuse typically don’t experience withdrawal symptoms even if engage in daily drinking, they will often experience unmanageability and their daily responsibilities or habits can take a backseat to drinking. Behaviors like oversleeping, repeatedly arriving late to work, forgetting plans with friends, becoming more argumentative with a spouse or partner or not taking care of yourself or your hygiene are all signs that alcohol is making it difficult to manage everyday life. This creates an ongoing cycle of increased stress and dysfunction.“Many people turn to alcohol to cope with these feelings of stress, fatigue or disorganization. Drinking becomes a primary coping method and, rather than finding healthy ways to cope with these feelings, alcohol abuse can progress into alcohol dependency,” explains Cirillo.',
    imageUrl: 'https://healingproperties.org/wp-content/uploads/2021/01/alcohol-use-disorder-scaled.jpg'),
  Learn(
    title: 'How Alcohol Abuse Can Affect Romantic Relationships',
    author: 'Discovery Mood & Anxiety Program',
    description:
       'Alcohol abuse disorder significantly alters an individual’s personality, and as a result, it can make them unrecognizable from the person they were before they started drinking. Individuals who have alcohol use disorder become more and more secretive, often out of fear, shame, or guilt. They begin to hide things from their significant other such as where they are, whom they are spending time with, and what they did during the day. Keeping the truth from your significant other may start as an innocent defense mechanism, but eventually, it will most likely lead to blatant lies and mistrust. As the alcohol abuse progresses, the lies an individual tells to cover their addiction become more elaborate over time. For their loved one, it can feel as if all they are hearing is excuse after excuse, for being late, for disappearing, for the mood swings, for the missing money, for the hidden bottles in the bathroom. Trust is essential to a healthy and functioning relationship, and once it is damaged, it can be difficult to repair. It can often lead to feelings of fear and jealousy. Because proper communication is impossible without honesty, both people could begin feeling alone and isolated, increasing feelings of sadness and resentment.',
    imageUrl:'https://3nih9o367186ft57b1fkswsq-wpengine.netdna-ssl.com/wp-content/uploads/2018/09/iStock-669740900-510x340.jpg' )
];