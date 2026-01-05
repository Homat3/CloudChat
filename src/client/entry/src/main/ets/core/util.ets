export function getAvatar(string: string): Resource{
  switch (string){
    case "default.png":
      return $r("app.media.default");
    case "avater/Zombatar_1.jpg":
      return $r("app.media.Zombatar_1");
    case "avater/Zombatar_2.jpg":
      return $r("app.media.Zombatar_2");
    case "avater/Zombatar_3.jpg":
      return $r("app.media.Zombatar_3");
    case "avater/Zombatar_4.jpg":
      return $r("app.media.Zombatar_4");
    case "avater/Zombatar_5.jpg":
      return $r("app.media.Zombatar_5");
    default :
      return $r("app.media.default");
  }
}
