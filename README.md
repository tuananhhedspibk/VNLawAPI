# APIの使い方

## /api/login
  + メソード: POST
  + form-data:
    - login[email]: lkbc.team@gmail.com
    - login[password]: 123456
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1

## /api/signup
  + メソード: POST
  + form-data:
    - signup[id]: 0ek12e0k12x20210x
    - signup[email]: lkbc.team@gmail.com
    - signup[password]: 123456
    - signup[password_confirmation]: 123456
    - signup[profile_attributes][displayName]: lkbc.team
    - signup[profile_attributes][userName]: lkbc.team.12309210
    - signup[user_role_attributes][role_id] = 1 [1: User, 2: Lawyer]
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1

## /api/logout
  + メソード: DELETE
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Token: dasmdsa9dsa9dad231
  + ログアウト後に新しいトケンが生まれられます。

## /api/users/[:user_name]
  + メソード: GET
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
  + 戻り値
    {
      user_info: {
        email: testnotifi@gmail.com,
        profile: {
          userName: testnotifi.1511420786026,
          displayName: testnotifi@gmail.com,
          photoURL: https://image.ibb.co/i23jUF/default_ava.png,
          birthday: null,
          created_at: 2018-03-25T04:56:48.176Z,
          updated_at: 2018-03-25T04:56:48.176Z
        },
        status: online
      }
    }

## /api/users/[:user_name]
  + メソード: PATCH
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Token: 213123213213213123
    - X-User-Email: test@gmail.com
  + form-data:
    - users[profile_attributes][displayName] = 123456
    - users[profile_attributes][avatar] = image.png
  + 戻り値
    {
      message: Update user success,
      profile: {
        displayName: 123456,
        birthday: 1990-08-28T00:00:00.000Z,
        userName: testnotifi.1511420786026,
        id: 1,
        photoURL: https://image.ibb.co/i23jUF/default_ava.png,
        created_at: 2018-03-25T04:56:48.176Z,
        updated_at: 2018-03-25T09:56:27.298Z
      }
    }

## /api/rooms
  + メソード: GET
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Token: 213123213213213123
    - X-User-Email: test@gmail.com
  + 戻り値
    {
      rooms: []
    }

## /api/rooms
  + メソード: POST
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Token: 213123213213213123
    - X-User-Email: test@gmail.com
  + form-data:
    - rooms[id] = 123456789
    - rooms[user_id] = 31921cm3md921d9m21
    - rooms[description] = 99e1samiimsasasasa -- [option]

## /api/rooms/[:room_id]
  + メソード: PATCH
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Token: 213123213213213123
    - X-User-Email: test@gmail.com
  + form-data:
    - rooms[description] = 123456789

## /api/lawyers/[:user_name]
  + メソード: GET
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
  + 戻り値
    {
      lawyer_info: {
        email: testnotifi@gmail.com,
        base_profile: {
          userName: testnotifi.1511420786026,
          displayName: testnotifi@gmail.com,
          photoURL: https://image.ibb.co/i23jUF/default_ava.png,
          birthday: null,
          created_at: 2018-03-25T04:56:48.176Z,
          updated_at: 2018-03-25T04:56:48.176Z
        },
        lawyer_profile: {
          id: 3,
          achievement: null,
          cardNumber: null,
          certificate: null,
          education: null,
          intro: null,
          price: null,
          exp: null,
          rate: null,
          workPlace: null
        },
        status: online
      }
    }

## /api/lawyers
  + メソード: POST
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
  + form-data:
    - lawyers[user_id]: 2319jc219c21321c
    - lawyers[achievement]: 1232132112312321 [option]
  + 戻り値
    {
      message: Create lawyer success,
      lawyer: {
        id: 5,
        achievement: null,
        cardNumber: null,
        certificate: null,
        education: null,
        intro: null,
        price: null,
        exp: null,
        rate: null,
        workPlace: null,
        created_at: 2018-03-27T16:33:09.502Z,
        updated_at: 2018-03-27T16:33:09.502Z
      }
    }

## /api/lawyers/[:lawyer_name]
  + メソード: PATCH
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + form-data:
    - lawyers[achievement]: 1232132112312321
  + 戻り値
    {
      message: Update lawyer success,
      lawyer_info: {
        base_profile: {
          userName: testnotifi_test2.1511420786026,
          displayName: testnotifi_test2,
          photoURL: https://image.ibb.co/i23jUF/default_ava.png,
          birthday: null,
          updated_at: 2018-03-26T16:57:37.498Z
        },
        lawyer_profile: {
          exp: 10,
          achievement: null,
          cardNumber: null,
          certificate: null,
          education: null,
          intro: null,
          price: null,
          rate: null,
          workPlace: null,
          updated_at: 2018-03-28T05:29:38.644Z
        }
      }
    }

## /api/lawyers/[:lawyer_name]/reviews
  + メソード: GET
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
  + 戻り値
    reviews: [
      {
        id: 3,
        content: Harry Potter and the Chamber of Secrets,
        star: 4,
        updated_at: 2018-03-26T16:57:26.803Z
      },
      {
        id: 6,
        content: Harry Potter and the Deathly Hallows,
        star: 2,
        updated_at: 2018-03-26T16:57:26.817Z
      },
      {
        id: 9,
        content: Harry Potter and the Goblet of Fire,
        star: 3,
        updated_at: 2018-03-26T16:57:26.831Z
      },
      {
        id: 12,
        content: Harry Potter and the Prisoner of Azkaban,
        star: 1,
        updated_at: 2018-03-26T16:57:26.844Z
      }
    ]

## /api/reviews
  + メソード: POST
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + form-data:
    - reviews[content]: 1232132112312321
    - reviews[star]: 1
    - reviews[lawyer_id]: 3
  + 戻り値
    {
      "message": "Create review success",
      "review": {
        "id": 14,
        "content": "123456",
        "star": 1,
        "created_at": "2018-03-29T09:41:05.300Z",
        "updated_at": "2018-03-29T09:41:05.300Z"
      }
    }

## /api/reviews/[:review_id]
  + メソード: PATCH
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + form-data:
    - reviews[content]: 1232132112312321
    - reviews[star]: 1
  + 戻り値
    {
      "message": "Update review success",
      "review": {
        "id": 14,
        "content": "hello world",
        "star": 1,
        "updated_at": "2018-03-29T13:50:47.357Z"
      }
    }

## /api/rooms/[:room_id]/tasks
  + メソード: GET
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + 戻り値
    {
      "tasks": [
        {
          "id": 12,
          "content": "Of course it is happening inside your head, Harry, but why on earth should that mean that it is not real?",
          "status": "Doing",
          "updated_at": "2018-03-29T09:32:51.539Z"
        },
        {
          "id": 13,
          "content": "hello world",
          "status": "Doing",
          "updated_at": "2018-03-29T15:02:56.300Z"
        }
      ]
    }

## /api/rooms/[:room_id]/tasks
  + メソード: POST
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + form-data:
    - tasks[content]: 1232132112312321
  + 戻り値
    {
      "tasks": [
        {
          "id": 12,
          "content": "Of course it is happening inside your head, Harry, but why on earth should that mean that it is not real?",
          "status": "Doing",
          "updated_at": "2018-03-29T09:32:51.539Z"
        },
        {
          "id": 13,
          "content": "hello world",
          "status": "Doing",
          "updated_at": "2018-03-29T15:02:56.300Z"
        },
        {
          "id": 14,
          "content": "abc",
          "status": "Doing",
          "updated_at": "2018-03-29T15:09:05.839Z"
        }
      ]
    }

## /api/rooms/[:room_id]/tasks/[:task_id]
  + メソード: PATCH
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + form-data:
    - tasks[content]: 1232132112312321
    - tasks[status]: "Done"
  + 戻り値
    {
      "messages": "Update task success",
      "task": {
        "id": 14,
        "status": "Done",
        "content": "abc123",
        "updated_at": "2018-03-29T15:29:40.173Z"
      }
    }

## /api/rooms/[:room_id]/tasks/[:task_id]
  + メソード: DELETE
  + headers:
    - X-Api-Token: 21c3j12c219jd21921j1
    - X-User-Email: testnotifi_test2@gmail.com
    - X-User-Token: vfGdEvig5hpK7iBPbxEr
  + 戻り値
    {
      "message": "Delete task success"
    }