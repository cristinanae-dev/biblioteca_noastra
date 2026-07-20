'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "88dc77c616884ab13b74b0cbbf835914",
"assets/AssetManifest.bin.json": "02230974836d086fb0889eed1d79db00",
"assets/AssetManifest.json": "597c0f22130586ab7d3e38fd732b3824",
"assets/assets/carti/crima_pedeapsa/audio_1.MP3": "b5ef22a552d3d8dbd412c866355d6bea",
"assets/assets/carti/crima_pedeapsa/audio_2.MP3": "3bfdfdde579bea57435e530abd37ba71",
"assets/assets/carti/crima_pedeapsa/audio_3.MP3": "94215315fb0e9eb5739cf8dd638de3ad",
"assets/assets/carti/crima_pedeapsa/audio_4.MP3": "9a4fd5e6d6ab41957e306391e5256a4e",
"assets/assets/carti/crima_pedeapsa/audio_5.MP3": "7cc47a84c399c96f0dfcbf92726853c4",
"assets/assets/carti/crima_pedeapsa/capitol1.txt": "c8dc0c80aa27a1a363b9d4fe7f434ae4",
"assets/assets/carti/crima_pedeapsa/capitol10.txt": "a7823afc6a4fdc19d3665da8df9d5a63",
"assets/assets/carti/crima_pedeapsa/capitol11.txt": "9e3f9ba17ba4926b5f06eaadec7d629c",
"assets/assets/carti/crima_pedeapsa/capitol12.txt": "5412a205a1f390c324efd1ec58c23b2f",
"assets/assets/carti/crima_pedeapsa/capitol13.txt": "df400e7c368abe4118a55435039c9c6f",
"assets/assets/carti/crima_pedeapsa/capitol14.txt": "7eabc015e03a73e752158989e86ff53f",
"assets/assets/carti/crima_pedeapsa/capitol15.txt": "c6491f477325b5dded9d46401669d61b",
"assets/assets/carti/crima_pedeapsa/capitol16.txt": "b2649f300655a3d1210773f176031f0b",
"assets/assets/carti/crima_pedeapsa/capitol17.txt": "9043355d6c487ba098b4b45030a24bf8",
"assets/assets/carti/crima_pedeapsa/capitol18.txt": "d24c4b8caf5e10d1b53eed79b347113b",
"assets/assets/carti/crima_pedeapsa/capitol19.txt": "44db1a5048e5b24e1fd19cb95acf5124",
"assets/assets/carti/crima_pedeapsa/capitol2.txt": "509c30ddbf73603a034b5920218c9f15",
"assets/assets/carti/crima_pedeapsa/capitol20.txt": "51bcde28e7d92fff66f644e0b1f7059d",
"assets/assets/carti/crima_pedeapsa/capitol21.txt": "4a84b075ebdcc159f7c461ba788915f9",
"assets/assets/carti/crima_pedeapsa/capitol22.txt": "adf4626bc4290ad024a0b7b4d5923c2d",
"assets/assets/carti/crima_pedeapsa/capitol3.txt": "7eff58906327388817a4efb8a6975f50",
"assets/assets/carti/crima_pedeapsa/capitol4.txt": "7271edcad25c49450d5bc16ab79d2e60",
"assets/assets/carti/crima_pedeapsa/capitol5.txt": "af188947b9525ca700b71a0385b3b92d",
"assets/assets/carti/crima_pedeapsa/capitol6.txt": "08f8c6e9bacd54277b23917fcb115cc0",
"assets/assets/carti/crima_pedeapsa/capitol7.txt": "f29ab56314728f0c0709dc66c118242c",
"assets/assets/carti/crima_pedeapsa/capitol8.txt": "17bda9ffc929ad367fa3db32524ba030",
"assets/assets/carti/crima_pedeapsa/capitol9.txt": "4e613a14364752b4aa385b97f9728124",
"assets/assets/carti/crima_pedeapsa/coperta.jpg": "6d6ceee63c3562af4fe700da956a9fda",
"assets/assets/carti/mos_goriot/audio_1.MP3": "4ca60dcc841b3c4e55305ae2c971026e",
"assets/assets/carti/mos_goriot/audio_2.MP3": "77bbaa8ac797f787020402deef9659ab",
"assets/assets/carti/mos_goriot/audio_3.MP3": "3d10600809589d52b28769ab420f8fcb",
"assets/assets/carti/mos_goriot/audio_4.MP3": "580ab30e89a36dbf5c11d10077cb6d76",
"assets/assets/carti/mos_goriot/audio_5.MP3": "85d8c2ea0176e91775a039ebcaf88b0b",
"assets/assets/carti/mos_goriot/capitol1.txt": "f816968cc857df09603b3810dddfff07",
"assets/assets/carti/mos_goriot/capitol10.txt": "29028fd8630372d9f370e4e9e71f82d7",
"assets/assets/carti/mos_goriot/capitol11.txt": "9e06ce4bb80a2f1480005dda62544b3b",
"assets/assets/carti/mos_goriot/capitol12.txt": "0c2c6c3574549841946f6846e1078f67",
"assets/assets/carti/mos_goriot/capitol13.txt": "4a2491f0c941e6cefac829aaa9890c10",
"assets/assets/carti/mos_goriot/capitol14.txt": "158c7d17c69bf0c9bb815bff545626f9",
"assets/assets/carti/mos_goriot/capitol15.txt": "cd77280466c04e7e6ca4792cfe8c53b8",
"assets/assets/carti/mos_goriot/capitol16.txt": "030ca560ba311cdeca750735eee0ca9f",
"assets/assets/carti/mos_goriot/capitol17.txt": "17aa5f3ff86978ae3aa39de3d7a7330f",
"assets/assets/carti/mos_goriot/capitol18.txt": "fe25581b46fccaa60a5b4256d81a984f",
"assets/assets/carti/mos_goriot/capitol19.txt": "a7a9cc71fa74d217ea6662b59c63607a",
"assets/assets/carti/mos_goriot/capitol2.txt": "1857f1f87bc3efe878baa1c049b15ebe",
"assets/assets/carti/mos_goriot/capitol20.txt": "7751ed14be377879623a669516449058",
"assets/assets/carti/mos_goriot/capitol21.txt": "a265608f3e72f49b51f0f684bf11d17d",
"assets/assets/carti/mos_goriot/capitol22.txt": "bea707afadbc3479700318e67c50e911",
"assets/assets/carti/mos_goriot/capitol3.txt": "9f9a7fcaa66e49061ba42107cf2f8a02",
"assets/assets/carti/mos_goriot/capitol4.txt": "5d815570289e71da297dffe1ce5140a3",
"assets/assets/carti/mos_goriot/capitol5.txt": "98ef3f2a942a2733d48aa967b6ec5e1b",
"assets/assets/carti/mos_goriot/capitol6.txt": "0359b63f4752d87184a1558bdc4b02b6",
"assets/assets/carti/mos_goriot/capitol7.txt": "51db916477b61226615737f53e1c3836",
"assets/assets/carti/mos_goriot/capitol8.txt": "034cc4f9f5726aea24956c6e18d4a1cf",
"assets/assets/carti/mos_goriot/capitol9.txt": "60779dfb7a569075b1f87b5233d6865c",
"assets/assets/carti/mos_goriot/coperta.jpg": "5effa0196e2b07f41315dc77a22bf235",
"assets/assets/carti/semizeul/audio_1.mp3": "65f5aa02f4bf2422f4724b5c5707c30e",
"assets/assets/carti/semizeul/audio_10.MP3": "42f4e35d9c826483cd5c9d685dc1c286",
"assets/assets/carti/semizeul/audio_11.MP3": "ca027f0600112d3b387ee19bc3f8ea39",
"assets/assets/carti/semizeul/audio_12.MP3": "f27fdb7668aec9c696e9602fd9aaf5de",
"assets/assets/carti/semizeul/audio_13.MP3": "dbbc845c3d42ab9c324881eeeb6ef762",
"assets/assets/carti/semizeul/audio_14.MP3": "04c1de3b77d7e54dcfc0b9806fb8ed98",
"assets/assets/carti/semizeul/audio_15.MP3": "8a787c0bb0921fced5b9192f75f07c49",
"assets/assets/carti/semizeul/audio_16.MP3": "7b783fdb04f591510872a07c1b2b8c19",
"assets/assets/carti/semizeul/audio_17.MP3": "86b64628abeacc03cb1cb23cb443b916",
"assets/assets/carti/semizeul/audio_18.MP3": "fd49c5867ae17eb6d1b86e5a53245d97",
"assets/assets/carti/semizeul/audio_19.MP3": "a1edfa2826982b7ecd10b01da35cdd60",
"assets/assets/carti/semizeul/audio_2.mp3": "cd8e37c63746578db48805eb1a551d91",
"assets/assets/carti/semizeul/audio_20.MP3": "28cf6542a62cc7c2ba1a89e114a1142f",
"assets/assets/carti/semizeul/audio_21.MP3": "1e9517e857af26a743aaa53cf3e1e2fd",
"assets/assets/carti/semizeul/audio_22.MP3": "4123a4cd260ceb652bf16b859316668c",
"assets/assets/carti/semizeul/audio_3.mp3": "22ce35e51ef8812bc3b4dd0af9dff3b6",
"assets/assets/carti/semizeul/audio_4.mp3": "fa96b77a8dc6f9e17931847ad35a6c26",
"assets/assets/carti/semizeul/audio_5.MP3": "688f68e68dab7db34f9b8e9100db7977",
"assets/assets/carti/semizeul/audio_6.MP3": "d660ca6dff4bbfb5c9b20785b2ad840e",
"assets/assets/carti/semizeul/audio_7.MP3": "79fc040d0ba325fcb09ec31701d52b48",
"assets/assets/carti/semizeul/audio_8.MP3": "ec522cbff7ec5d586140e41516079ad3",
"assets/assets/carti/semizeul/audio_9.MP3": "1a969aac83e5a0aeb060e3915a0c46f7",
"assets/assets/carti/semizeul/capitol_1.txt": "29922d901470ab1896a15cbf3f4e73f1",
"assets/assets/carti/semizeul/capitol_10.txt": "63fcda380b865e7cb6bff47ffdb44dd1",
"assets/assets/carti/semizeul/capitol_11.txt": "0a92656ce17664d5887f4c2d69c110a7",
"assets/assets/carti/semizeul/capitol_12.txt": "4beb537ad70186d329795b921ebd07e1",
"assets/assets/carti/semizeul/capitol_13.txt": "9a8d44839726b4a4b7c87e2f71f57bb7",
"assets/assets/carti/semizeul/capitol_14.txt": "f8678efa0877ecdf037913ea4fd339d3",
"assets/assets/carti/semizeul/capitol_15.txt": "64489bd265ec96b9381f8b5f5770beca",
"assets/assets/carti/semizeul/capitol_16.txt": "03ca3621f1d9b30b34e5fb9dda88f2cd",
"assets/assets/carti/semizeul/capitol_17.txt": "db5aab1753e5c59676310d151bc73d79",
"assets/assets/carti/semizeul/capitol_18.txt": "f1c77a98a0c8f5d6e4f4ac8ce1ceeebd",
"assets/assets/carti/semizeul/capitol_19.txt": "bc934b608fddff81b20b31268f09aab9",
"assets/assets/carti/semizeul/capitol_2.txt": "81d70d565dbb008d37b91b522b78ac9b",
"assets/assets/carti/semizeul/capitol_20.txt": "9538f128000f9c4cffe88cb2fa398a61",
"assets/assets/carti/semizeul/capitol_21.txt": "9a6f808882b8c99fed6e884e2df0b641",
"assets/assets/carti/semizeul/capitol_22.txt": "89a9c010d09ee3869e66296561afbe66",
"assets/assets/carti/semizeul/capitol_3.txt": "8fe1b79b0b468918d2cf3b1cce0da877",
"assets/assets/carti/semizeul/capitol_4.txt": "f163421f030bba60efcb3499df7d0d78",
"assets/assets/carti/semizeul/capitol_5.txt": "24e97d81106c7cc35373f5c39a598a3b",
"assets/assets/carti/semizeul/capitol_6.txt": "e12b80cec3628b0715acc11c630204d8",
"assets/assets/carti/semizeul/capitol_7.txt": "d5f5a24153ee8734f898b3e1061ede61",
"assets/assets/carti/semizeul/capitol_8.txt": "04696b6e6ae74f46f7b2b90442b5d33b",
"assets/assets/carti/semizeul/capitol_9.txt": "220304f492ecf2cca061ad6661dd733f",
"assets/assets/carti/semizeul/semizeul.jpg": "c176b2c2675f9e8d902d0c2ba7ca41fb",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "76e1d1019b6f28241ebdfc8807893536",
"assets/NOTICES": "f758dc12fc3d72522a31c5967eb169ec",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "ba1d47725845358869e3155d07b18279",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "89ebd97da4320fd9498b91b1ba149a05",
"/": "89ebd97da4320fd9498b91b1ba149a05",
"main.dart.js": "cab647bd70a76c3602eee52b83fc1ee1",
"manifest.json": "25c74d48f452c31ac77eb504b9cbed04",
"version.json": "18a859d6e2071033c24cd3d5e81f2ec5"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
