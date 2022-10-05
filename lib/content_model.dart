class UnbordingContent {
  String image;
  String vimage;
  String title;
  String discription;

  UnbordingContent({this.image, this.title, this.discription, this.vimage});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Welcome to Vuwala',
      image: 'images/one.png',
      vimage: 'images/Vuwala.png',
      discription: "Vuwala allows you to create the best version of You from the palm of your hand!"),
  UnbordingContent(
      title: 'Find Your Perfect Provider',
      image: 'images/two.png',
      vimage: null,
      discription: "Use our search feature to find providers based on type and location"),
  UnbordingContent(
      title: 'Easily Book!', image: 'images/three.png', vimage: null, discription: "Easily book and manage appointments with the click of a button!"),
  UnbordingContent(
      title: 'Gain Rewards!',
      image: 'images/four.png',
      vimage: null,
      discription: "Earn Vuwala points for every appointment booked,redeemable at select providers!"),
];
