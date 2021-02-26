[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">

<h3 align="center">FiveM Fishing</h3>

  <p align="center">
    <br />
    ·
    <a href="https://github.com/cyntaax/fivem-fishing/issues">Report Bug</a>
    ·
    <a href="https://github.com/cyntaax/fivem-fishing/issues">Request Feature</a>
  </p>
</p>




<!-- ABOUT THE PROJECT -->
## About The Project

![product-screenshot](https://i.gyazo.com/268f17b6814049b8855ca3b9f384a68c.png)


<!-- GETTING STARTED -->
## Getting Started

Simply download the [Latest Release](), place into your resources directory and start!

### Prerequisites

To get this resource working properly for your exact use, you will have to configure the functionality for giving a player an item.

### Server Exports
---

### SetGivePlayerItem(source: number, item: string, amount: number)

- This export will be used to overwrite the functionality of giving a player an item. For example -

```lua
---
exports.fishing:SetGivePlayerItem(function(source, item, amount)
  TriggerEvent('myInventory:givePlayerItem', source, item, amount)
end)
```



### Configuration

Configuration is to be set in the `config.json` and should match the following format. There can be an infinite amount of lures and catches.

The `key` cooresponds to keys found [here](https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/)



```json
{
  "key": "PERIOD",
  "lures": [
    {
      "name": "lure_basic_01",
      "label": "Basic Lure",
      "catches": [
        {
          "name": "small_fish_01",
          "label": "Small Fish",
          "prob": 10
        }
      ]
    }
  ]
}
```

> A small explaination of the `prob` property. It is the probability to which a player can catch that item, it is relational between all catches.

#### Prob examples

```json
{
  "key": "PERIOD",
  "lures": [
    {
      "name": "lure_basic_01",
      "label": "Basic Lure",
      "catches": [
        {
          "name": "small_fish_01",
          "label": "Small Fish",
          "prob": 10
        },
        {
          "name": "medium_fish_01",
          "label": "Medium Fish",
          "prob": 5
        }
      ]
    }
  ]
}
```

In the above example we have 2 catches. The first has a probability of 10 the second has a probability of 5. The system will create a pool of **15** items. (sum of the probability of all catches). This pool will contain 10 entries of small_fish_01 and 5 entries of medium_fish_01 meaning that there is a 67% chance of getting a small fish and a 33% chance of getting a medium fish.


## Additional Exports


### Server
---

### SetLureForPlayer(source, lure)
  -  Running this function will equip the specified lure for a player



### Client
---

### SetShowMessage(message: string, messageType: string)
  - Use this to replace the functionality of displaying messages (i.e. you are using some *REALLY* cool notification system that is just so much better than the native)

e.g.

```lua
exports.fishing:SetShowMessage(function(message, messageType)
  TriggerEvent('mycoolsystem:showNotification', message)
end)
```

### SetOnTestingProgress(progress: number)
  - Use this export to replace the function that runs whenever the progress is updated for the test to see if a player can fish (i.e. you are using some OTHER REALLY COOL progress bar system that is so much better than the native)
  - **This will be called every frame while the testing is in progress**


### SetTestingComplete(result: boolean)
  - This function will be fired when the testing has completed, along with the result specifying whether or not the test was successful


### SetOnFishCaught(fish: string, cb: fun(): void)
  - This function will be fired once a player has caught a fish. Do with it what you will. The `cb` **MUST** be called for the process to continue.

### SetOnCatchPending()
  - This function will be called every frame while a catch is pending. The default functionality is to just display a prompt at the top left to reel in. Change this to your liking.



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/cyntaax/fivem-fishing/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'chore: added some amazing feature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Cyntaax - [@cyntaax](https://twitter.com/cyntaax) - cyntaax@gmail.com

Project Link: [https://github.com/cyntaax/fivem-fishing](https://github.com/cyntaax/fivem-fishing)







<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/cyntaax/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/cyntaax/repo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/cyntaax/repo.svg?style=for-the-badge
[forks-url]: https://github.com/cyntaax/repo/network/members
[stars-shield]: https://img.shields.io/github/stars/cyntaax/repo.svg?style=for-the-badge
[stars-url]: https://github.com/cyntaax/repo/stargazers
[issues-shield]: https://img.shields.io/github/issues/cyntaax/repo.svg?style=for-the-badge
[issues-url]: https://github.com/cyntaax/repo/issues
[license-shield]: https://img.shields.io/github/license/cyntaax/repo.svg?style=for-the-badge
[license-url]: https://github.com/cyntaax/repo/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/cyntaax